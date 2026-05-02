const { app } = require("@azure/functions");
const { randomUUID } = require("crypto");
const { containers, queryAll, upsertMany, withMetadata } = require("../lib/cosmos");
const { badRequest, json, options, requireApiKey, unauthorized } = require("../lib/http");

function normalizeStation(input) {
  const campaignId = input.campaignId || "default";
  const id = input.id || `${campaignId}-${randomUUID()}`;
  return withMetadata(input, {
    id,
    campaignId,
    type: "station"
  });
}

app.http("stations", {
  route: "stations",
  methods: ["GET", "POST", "OPTIONS"],
  authLevel: "anonymous",
  handler: async (request) => {
    if (request.method === "OPTIONS") return options(request);
    if (!requireApiKey(request)) return unauthorized(request);

    const { stations } = containers();

    if (request.method === "GET") {
      const campaignId = request.query.get("campaignId") || "default";
      const items = await queryAll(stations, {
        query: "SELECT * FROM c WHERE c.campaignId = @campaignId ORDER BY c.updatedAt DESC",
        parameters: [{ name: "@campaignId", value: campaignId }]
      });
      return json(request, 200, { ok: true, stations: items });
    }

    const body = await request.json();
    const input = Array.isArray(body) ? body : body.stations || [body];
    if (!Array.isArray(input)) return badRequest(request, "Expected station object or stations array.");

    const saved = await upsertMany(stations, input.map(normalizeStation));
    return json(request, 200, { ok: true, count: saved.length, stations: saved });
  }
});
