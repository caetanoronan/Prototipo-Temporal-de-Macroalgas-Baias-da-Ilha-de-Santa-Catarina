# Render local do mapa

Servidor local para exportar PNG do mapa do protótipo usando Playwright.

## Instalação

```bash
npm install
npx playwright install chromium
```

## Uso

```bash
npm start
```

No mapa principal, a exportação PNG passa a chamar:

```text
http://127.0.0.1:3030/render.png?layers=...&ref=...&base=...
```

O servidor abre a página do mapa, espera o render real do Leaflet e captura somente a área do mapa.

## Render em nuvem (Render.com)

Este diretório já inclui `Dockerfile` para deploy containerizado.

### Variáveis de ambiente

- `PORT`: porta do serviço (use `3030`)
- `MAP_SOURCE_URL`: URL pública da página do mapa para screenshot
- `ALLOWED_ORIGIN`: origem permitida para CORS (`*` para público)

Exemplo:

```text
PORT=3030
MAP_SOURCE_URL=https://SEU-USUARIO.github.io/SEU-REPO/05_gis_mapas/mapa_prototipo_armacao_infra_clone.html
ALLOWED_ORIGIN=*
```

### Testes após deploy

```text
GET https://SEU-SERVICO.onrender.com/health
GET https://SEU-SERVICO.onrender.com/render.png?layers=quadrat_photo,water_probe&ref=&base=osm&filename=teste_cloud
```

O endpoint `/health` deve retornar `ok: true`.
