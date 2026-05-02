const { app } = require("@azure/functions");
const { json, options } = require("../lib/http");

app.http("health", {
  route: "health",
  methods: ["GET", "OPTIONS"],
  authLevel: "anonymous",
  handler: async (request) => {
    if (request.method === "OPTIONS") return options(request);

    return json(request, 200, {
      ok: true,
      service: "macroalgas-field-api",
      version: "0.1.0",
      time: new Date().toISOString()
    });
  }
});
