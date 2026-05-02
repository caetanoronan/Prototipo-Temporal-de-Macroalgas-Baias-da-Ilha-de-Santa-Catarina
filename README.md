# Prototipo_Armação

Protótipo de campo do Projeto de Mestrado (PPGOceano/UFSC) para validação cartográfica, coleta em campo, usabilidade e exportação de mapas em PNG.

## Visão geral

Este repositório reúne o portal do protótipo, a metodologia, o aplicativo de campo, o mapa operacional, o dashboard e os guias de uso. O fluxo foi pensado para uso prático em campo, com armazenamento local no navegador e exportação dos registros ao final de cada estação ou bloco de trabalho.

## Como abrir

Abra `index.html` para acessar a página principal do protótipo.

## Componentes principais

- `01_planejamento/metodologia_prototipo_macroalgas.html` - metodologia e ficha de campo
- `03_formularios/app_campo_macroalgas.html` - aplicativo de coleta em campo
- `03_formularios/GUIA_USO_APP_CAMPO.html` - guia operacional e validação
- `05_gis_mapas/mapa_prototipo_armacao_clone.html` - mapa operacional principal
- `05_gis_mapas/mapa_prototipo_armacao_infra_clone.html` - mapa para fluxo de render e exportação PNG
- `05_gis_mapas/pagina_impressao_prototipo_armacao.html` - página de apoio para impressão
- `dashboard_macroalgas_baias_clone.html` - painel analítico consolidado
- `render/server.js` - serviço local para exportação PNG via render

## Coleta em campo

O aplicativo de campo salva estações, quadrados, rascunhos e tema apenas no navegador do aparelho usado na campanha. Para evitar perda de dados, use sempre o mesmo celular ou tablet durante a saída, exporte o backup ao final de cada estação ou bloco e não limpe o navegador antes de gerar os arquivos.

Se houver troca de aparelho, exporte o JSON no aparelho antigo e importe-o no novo antes de continuar a coleta.

## Exportação PNG

Há duas formas de exportar PNG:

1. Render local com `render/server.js`.
2. Render remoto, caso o serviço seja publicado em nuvem.

No fluxo local, instale as dependências do diretório `render`, inicie o serviço e use a versão infra do mapa para gerar a imagem com alinhamento cartográfico mais estável.

## Protocolo operacional

Para operação diária, validação e contingência, consulte:

- `01_planejamento/PROTOCOLO_OPERACAO_EXPORTACAO_PNG.md`
- `01_planejamento/PROTOCOLO_OPERACAO_CAMPO_1_PAGINA.md`
- `01_planejamento/OPERACAO_CAMPO_RAPIDA.html`

## Autoria e programa

Projeto de Mestrado - PPGOceano/UFSC - 2026
Autor: Ronan Armando Caetano  
Programa: Pós-Graduação em Oceanografia (PPGOceano/UFSC) / CAPES
