# Protocolo de Operacao Completa - Exportacao PNG (Mapa Armacao)

## Objetivo

Garantir que qualquer pessoa consiga abrir o mapa publico e exportar PNG com os pontos, em qualquer lugar, sem depender do computador local do autor.

## Versao resumida para campo

Para uso rapido em celular/notebook durante operacao de campo:

- `01_planejamento/PROTOCOLO_OPERACAO_CAMPO_1_PAGINA.md`
- `01_planejamento/OPERACAO_CAMPO_RAPIDA.html`

## Escopo

Este protocolo cobre:

- Operacao diaria do mapa publico
- Validacao de disponibilidade do servico de render na nuvem
- Procedimento de contingencia
- Checklist de manutencao

## Endpoints oficiais

- Mapa publico:
  - https://caetanoronan.github.io/prototipo-armacao/05_gis_mapas/mapa_prototipo_armacao_infra_clone.html
- Render cloud:
  - https://prototipo-praia-armacao.onrender.com
- Health check:
  - https://prototipo-praia-armacao.onrender.com/health

## Rotina de operacao diaria (usuario final)

1. Abrir o mapa publico.
2. Selecionar camadas e, se necessario, ponto de referencia.
3. Definir o nome do arquivo no campo de nome.
4. Clicar em Exportar PNG.
5. Confirmar download do arquivo na pasta padrao do dispositivo.

## Rotina de validacao rapida (2 minutos)

1. Acessar o endpoint de health.
2. Confirmar retorno com ok true.
3. Rodar teste direto de exportacao:
   - https://prototipo-praia-armacao.onrender.com/render.png?layers=quadrat_photo&ref=&base=osm&filename=teste_operacional
4. Confirmar que o arquivo teste_operacional.png foi baixado.

## Criterios de aceite operacional

Sistema considerado OK quando:

- Health responde com ok true
- Exportacao via botao Exportar PNG funciona no mapa publico
- Exportacao direta via endpoint render.png retorna imagem valida

## Contingencia (quando falhar)

### Caso A - Health indisponivel

1. Aguardar 30-90 segundos (plano free pode entrar em cold start).
2. Repetir teste de health.
3. Se persistir, abrir painel do Render e verificar ultimo deploy.

### Caso B - Health OK, mas exportacao falha

1. Testar render.png direto no navegador.
2. Se render.png falhar com erro de Playwright:
   - Verificar Build Command no Render:
     - npm install; npx playwright install chromium
   - Verificar variaveis de ambiente:
     - PLAYWRIGHT_BROWSERS_PATH=0
     - ALLOWED_ORIGIN=*
     - MAP_SOURCE_URL=<url publica do mapa>
3. Rodar Clear build cache and deploy.

### Caso C - Mapa abre, mas pontos/camadas nao aparecem no PNG

1. Confirmar que MAP_SOURCE_URL aponta para a pagina correta do infra clone.
2. Confirmar que o CSV de dados esta acessivel no GitHub Pages.
3. Repetir exportacao apos recarga completa da pagina.

## Checklist de configuracao Render (referencia)

- Root Directory: render
- Build Command: npm install; npx playwright install chromium
- Start Command: npm start
- Health Check Path: /health
- Variaveis:
  - PLAYWRIGHT_BROWSERS_PATH=0
  - ALLOWED_ORIGIN=*
  - MAP_SOURCE_URL=https://caetanoronan.github.io/prototipo-armacao/05_gis_mapas/mapa_prototipo_armacao_infra_clone.html

## Manutencao semanal recomendada

1. Executar validacao rapida.
2. Exportar 1 PNG de teste com 2 camadas diferentes.
3. Registrar resultado em log simples (data, status, observacao).
4. Em caso de falha recorrente, redeploy manual no Render.

## Registro de incidentes (modelo)

- Data e hora:
- Sintoma observado:
- Endpoint health:
- Resultado render.png direto:
- Acao aplicada:
- Resultado final:

## Responsavel tecnico

- Projeto: Prototipo Praia Armacao
- Responsavel: Ronan Armando Caetano
