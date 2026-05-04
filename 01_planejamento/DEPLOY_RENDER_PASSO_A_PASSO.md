# Deploy do Serviço de Render PNG no Render.com

## Problema Atual
O mapa publicado no GitHub Pages exporta PNG usando um endpoint de render em produção na nuvem. O endpoint local (`http://127.0.0.1:3030`) só serve para testes no computador do autor.

## Solução
O serviço de render está publicado em produção e deve ser usado como endpoint oficial.

### Endpoint oficial
- Render live: https://prototipo-temporal-de-macroalgas-baias.onrender.com
- Health check: https://prototipo-temporal-de-macroalgas-baias.onrender.com/health
- PNG direto: https://prototipo-temporal-de-macroalgas-baias.onrender.com/render.png?layers=quadrat_photo&ref=&base=osm&filename=teste

### Configuração do mapa
No arquivo [05_gis_mapas/mapa_prototipo_armacao_infra_clone.html](../05_gis_mapas/mapa_prototipo_armacao_infra_clone.html), a variável `DEFAULT_CLOUD_RENDER` deve apontar para:

```javascript
const DEFAULT_CLOUD_RENDER = 'https://prototipo-temporal-de-macroalgas-baias.onrender.com';
```

### Verificação rápida
1. Abrir a página do mapa infra.
2. Selecionar camadas e ponto de referência, se necessário.
3. Definir o nome do arquivo.
4. Clicar em Exportar PNG.
5. Confirmar o download do arquivo PNG.

### Observações
- Se o navegador estiver com cache antigo, faça recarga forçada.
- Se houver falha no PNG, testar diretamente o endpoint `/render.png`.
- O mapa infra e o serviço Render devem permanecer com a mesma URL pública.
