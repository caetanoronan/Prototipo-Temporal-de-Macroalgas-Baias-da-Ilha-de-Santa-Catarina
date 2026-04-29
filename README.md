# Prototipo_Armação

Protótipo de campo do Projeto de Mestrado (PPGOceano/UFSC) para validação cartográfica, usabilidade em coleta e exportação de mapas em PNG.

## Página principal

Abra `index.html` para visualizar:

- Mapa A: clone operacional
- Mapa B: infra clone com fluxo de render
- Explicação pública dos objetivos de teste em campo

## Estrutura essencial

- `05_gis_mapas/mapa_prototipo_armacao_clone.html`
- `05_gis_mapas/mapa_prototipo_armacao_infra_clone.html`
- `05_gis_mapas/pagina_impressao_prototipo_armacao.html`
- `04_dados_campo/raw/referencias_prototipo_armacao.csv`
- `render/server.js`

## Exportação PNG com render local

No diretório `render`:

```bash
npm install
npx playwright install chromium
npm start
```

Com o serviço ativo em `http://127.0.0.1:3030`, a versão infra do mapa exporta PNG com alinhamento cartográfico mais estável.

## Exportação PNG 100% online (sem servidor local)

Para não depender do computador local, publique `render/server.js` como um serviço web (ex.: Render.com).

### 1) Deploy do render na nuvem

O diretório `render/` já está preparado com `Dockerfile`.

No Render.com:

1. Crie um novo **Web Service** conectado ao repositório.
2. Configure o serviço para usar o diretório `render`.
3. Defina as variáveis de ambiente:
	- `PORT=3030`
	- `MAP_SOURCE_URL=https://SEU-USUARIO.github.io/SEU-REPO/05_gis_mapas/mapa_prototipo_armacao_infra_clone.html`
	- `ALLOWED_ORIGIN=*`
4. Publique e anote a URL final do serviço (ex.: `https://prototipo-armacao-render.onrender.com`).

### 2) Apontar o mapa para o serviço cloud

No arquivo `05_gis_mapas/mapa_prototipo_armacao_infra_clone.html`, altere:

```js
const DEFAULT_CLOUD_RENDER = 'https://SEU-SERVICO-RENDER.onrender.com';
```

Substitua pelo endpoint real do Render.

### 3) Teste rápido

Com o site público aberto:

1. Selecione camadas/ponto de referência.
2. Clique em **Exportar PNG**.
3. O download deve funcionar mesmo com `127.0.0.1:3030` desligado.

## Protocolo operacional

Para operação diária, validação e contingência de exportação PNG:

- `01_planejamento/PROTOCOLO_OPERACAO_EXPORTACAO_PNG.md`
- `01_planejamento/PROTOCOLO_OPERACAO_CAMPO_1_PAGINA.md`
- `01_planejamento/OPERACAO_CAMPO_RAPIDA.html`

## Autoria e programa

Projeto de Mestrado — PPGOceano/UFSC · 2026  
Autor: Ronan Armando Caetano  
Programa: Pós-Graduação em Oceanografia (PPGOceano/UFSC) / CAPES
