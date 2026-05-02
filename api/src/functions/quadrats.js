const { app } = require("@azure/functions");
const { randomUUID } = require("crypto");
const { containers, queryAll, upsertMany, withMetadata } = require("../lib/cosmos");
const { badRequest, json, options, requireApiKey, unauthorized } = require("../lib/http");

function normalizeQuadrat(input) {
  const stationId = input.stationId || "unknown-station";
  const quadrat = input.quadrat || "Q?";
  const id = input.id || `${stationId}-${quadrat}` || randomUUID();
  return withMetadata(input, {
    id,
    stationId,
    campaignId: input.campaignId || "default",
    type: "quadrat"
  });
}

app.http("quadrats", {
  route: "quadrats",
  methods: ["GET", "POST", "OPTIONS"],
  authLevel: "anonymous",
  handler: async (request) => {
    if (request.method === "OPTIONS") return options(request);
    if (!requireApiKey(request)) return unauthorized(request);

    const { quadrats } = containers();

    if (request.method === "GET") {
      const stationId = request.query.get("stationId");
      const campaignId = request.query.get("campaignId") || "default";
      const querySpec = stationId
        ? {
            query: "SELECT * FROM c WHERE c.stationId = @stationId ORDER BY c.quadrat",
            parameters: [{ name: "@stationId", value: stationId }]
          }
        : {
            query: "SELECT * FROM c WHERE c.campaignId = @campaignId ORDER BY c.stationId, c.quadrat",
            parameters: [{ name: "@campaignId", value: campaignId }]
          };
      const items = await queryAll(quadrats, querySpec);
      return json(request, 200, { ok: true, quadrats: items });
    }

    const body = await request.json();
    const input = Array.isArray(body) ? body : body.quadrats || [body];
    if (!Array.isArray(input)) return badRequest(request, "Expected quadrat object or quadrats array.");

    const saved = await upsertMany(quadrats, input.map(normalizeQuadrat));
    return json(request, 200, { ok: true, count: saved.length, quadrats: saved });
  }
});
