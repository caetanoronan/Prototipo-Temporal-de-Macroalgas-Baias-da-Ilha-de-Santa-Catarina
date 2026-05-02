const { app } = require("@azure/functions");
const { randomUUID } = require("crypto");
const { containers, nowIso, upsertMany, withMetadata } = require("../lib/cosmos");
const { badRequest, json, options, requireApiKey, unauthorized } = require("../lib/http");

function normalizeStation(input, context) {
  const campaignId = input.campaignId || context.campaignId;
  return withMetadata(input, {
    id: input.id || `${campaignId}-${randomUUID()}`,
    campaignId,
    deviceId: input.deviceId || context.deviceId,
    type: "station"
  });
}

function normalizeQuadrat(input, context) {
  const stationId = input.stationId || "unknown-station";
  const quadrat = input.quadrat || "Q?";
  return withMetadata(input, {
    id: input.id || `${stationId}-${quadrat}`,
    stationId,
    campaignId: input.campaignId || context.campaignId,
    deviceId: input.deviceId || context.deviceId,
    type: "quadrat"
  });
}

app.http("sync", {
  route: "sync",
  methods: ["POST", "OPTIONS"],
  authLevel: "anonymous",
  handler: async (request) => {
    if (request.method === "OPTIONS") return options(request);
    if (!requireApiKey(request)) return unauthorized(request);

    const body = await request.json();
    const campaignId = body.campaignId || "default";
    const deviceId = body.deviceId || "unknown-device";
    const stationsInput = Array.isArray(body.stations) ? body.stations : [];
    const quadratsInput = Array.isArray(body.quadrats) ? body.quadrats : [];

    if (!stationsInput.length && !quadratsInput.length) {
      return badRequest(request, "Expected stations or quadrats to sync.");
    }

    const { stations, quadrats, syncEvents } = containers();
    const context = { campaignId, deviceId };
    const savedStations = await upsertMany(stations, stationsInput.map((item) => normalizeStation(item, context)));
    const savedQuadrats = await upsertMany(quadrats, quadratsInput.map((item) => normalizeQuadrat(item, context)));

    const event = {
      id: randomUUID(),
      campaignId,
      deviceId,
      type: "sync",
      stationCount: savedStations.length,
      quadratCount: savedQuadrats.length,
      createdAt: nowIso()
    };
    await syncEvents.items.upsert(event);

    return json(request, 200, {
      ok: true,
      event,
      stationCount: savedStations.length,
      quadratCount: savedQuadrats.length
    });
  }
});
