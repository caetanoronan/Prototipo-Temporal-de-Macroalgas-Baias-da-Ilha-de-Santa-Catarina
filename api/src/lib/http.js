function allowedOrigins() {
  return String(process.env.CORS_ALLOWED_ORIGINS || "")
    .split(",")
    .map((origin) => origin.trim())
    .filter(Boolean);
}

function corsHeaders(request) {
  const origin = request.headers.get("origin") || "";
  const allowed = allowedOrigins();
  const allowOrigin = allowed.includes(origin) ? origin : allowed[0] || "*";

  return {
    "Access-Control-Allow-Origin": allowOrigin,
    "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
    "Access-Control-Allow-Headers": "content-type,x-api-key",
    "Access-Control-Max-Age": "86400",
    "Content-Type": "application/json"
  };
}

function json(request, status, body) {
  return {
    status,
    headers: corsHeaders(request),
    jsonBody: body
  };
}

function options(request) {
  return {
    status: 204,
    headers: corsHeaders(request)
  };
}

function unauthorized(request) {
  return json(request, 401, {
    ok: false,
    error: "unauthorized"
  });
}

function requireApiKey(request) {
  const expected = process.env.API_KEY;
  if (!expected) return true;
  const actual = request.headers.get("x-api-key") || request.query.get("api_key");
  return actual === expected;
}

function badRequest(request, message) {
  return json(request, 400, {
    ok: false,
    error: message
  });
}

module.exports = {
  badRequest,
  json,
  options,
  requireApiKey,
  unauthorized
};
