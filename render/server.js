const http = require('http');
const { chromium } = require('playwright');

const PORT = Number(process.env.PORT || 3030);
const MAP_SOURCE_URL = safeText(process.env.MAP_SOURCE_URL) || 'https://caetanoronan.github.io/Prototipo-Temporal-de-Macroalgas-Baias-da-Ilha-de-Santa-Catarina/05_gis_mapas/mapa_prototipo_armacao_infra_clone.html';
const ALLOWED_ORIGIN = safeText(process.env.ALLOWED_ORIGIN) || '*';

const DEFAULT_HEADERS = {
  'Access-Control-Allow-Origin': ALLOWED_ORIGIN,
  'Access-Control-Allow-Methods': 'GET, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type'
};

function sendJson(res, statusCode, payload) {
  res.writeHead(statusCode, {
    'Content-Type': 'application/json; charset=utf-8',
    ...DEFAULT_HEADERS
  });
  res.end(JSON.stringify(payload));
}

function safeText(value) {
  return String(value || '').replace(/[\r\n]+/g, ' ').trim();
}

function safeFilename(value) {
  const cleaned = safeText(value)
    .replace(/[\\/:*?"<>|]+/g, '_')
    .replace(/\s+/g, '_')
    .slice(0, 120);
  return cleaned || 'mapa_piloto_macroalgas';
}

function buildMapUrl(query) {
  if (!MAP_SOURCE_URL) {
    throw new Error('MAP_SOURCE_URL environment variable is not set');
  }
  const url = new URL(MAP_SOURCE_URL);
  ['layers', 'ref', 'base'].forEach((key) => {
    const value = safeText(query[key]);
    if (value) url.searchParams.set(key, value);
  });
  return url.toString();
}

async function renderPng(query) {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 1760, height: 1080 }, deviceScaleFactor: 2 });

  try {
    await page.goto(buildMapUrl(query), { waitUntil: 'domcontentloaded' });
    await page.waitForFunction(() => window.__mapReady === true, null, { timeout: 60000 });
    await page.waitForTimeout(1500);

    const area = page.locator('#exportArea');
    const buffer = await area.screenshot({ type: 'png' });
    return buffer;
  } finally {
    await page.close().catch(() => {});
    await browser.close().catch(() => {});
  }
}

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://127.0.0.1:${PORT}`);

  if (req.method === 'OPTIONS') {
    res.writeHead(204, DEFAULT_HEADERS);
    res.end();
    return;
  }

  if (url.pathname === '/health') {
    return sendJson(res, 200, {
      ok: true,
      mode: 'cloud-url',
      mapSource: MAP_SOURCE_URL
    });
  }

  if (url.pathname === '/render.png') {
    try {
      const filename = safeFilename(url.searchParams.get('filename'));
      const buffer = await renderPng({
        layers: url.searchParams.get('layers'),
        ref: url.searchParams.get('ref'),
        base: url.searchParams.get('base')
      });

      res.writeHead(200, {
        'Content-Type': 'image/png',
        'Content-Disposition': `inline; filename="${filename}.png"`,
        ...DEFAULT_HEADERS
      });
      res.end(buffer);
    } catch (error) {
      sendJson(res, 500, { ok: false, error: error.message || String(error) });
    }
    return;
  }

  sendJson(res, 404, { ok: false, error: 'Not found' });
});

server.listen(PORT, () => {
  console.log(`Render server listening on port ${PORT}`);
  console.log(`Map source: ${MAP_SOURCE_URL}`);
});
