# Protótipo Temporal de Macroalgas - Baías da Ilha de Santa Catarina

Protótipo de campo do Projeto de Mestrado do PPGOceano/UFSC voltado à validação cartográfica, coleta em campo, usabilidade do app e exportação de mapas em PNG.

## Site publicado

Versão pública do projeto: https://caetanoronan.github.io/Prototipo-Temporal-de-Macroalgas-Baias-da-Ilha-de-Santa-Catarina/

O portal concentra os produtos desta etapa do trabalho e mantém o mesmo vocabulário usado nas saídas de campo, na metodologia e nas análises históricas.

## O que este repositório reúne

- Portal principal com acesso aos produtos do protótipo.
- Mapa operacional com seis estações e camadas metodológicas.
- Metodologia de campo com ficha, pré-campo e materiais.
- App de campo offline-first, com armazenamento local no navegador e sincronização com Supabase.
- Guia de uso e validação do app, já testado em múltiplas abas e em celular.
- Dashboard com os resultados consolidados.
- Legendas históricas e arquivos de apoio para apresentação e leitura dos dados.

## Produtos publicados

- [index.html](index.html) - portal principal do protótipo
- [05_gis_mapas/mapa_prototipo_armacao_clone.html](05_gis_mapas/mapa_prototipo_armacao_clone.html) - mapa operacional
- [05_gis_mapas/mapa_prototipo_armacao_infra_clone.html](05_gis_mapas/mapa_prototipo_armacao_infra_clone.html) - mapa infra para render PNG
- [01_planejamento/metodologia_prototipo_macroalgas.html](01_planejamento/metodologia_prototipo_macroalgas.html) - metodologia e ficha de campo
- [03_formularios/app_campo_macroalgas.html](03_formularios/app_campo_macroalgas.html) - app de coleta em campo
- [03_formularios/GUIA_USO_APP_CAMPO.html](03_formularios/GUIA_USO_APP_CAMPO.html) - guia operacional do app
- [dashboard_macroalgas_baias_clone.html](dashboard_macroalgas_baias_clone.html) - dashboard de resultados
- [05_gis_mapas/pagina_impressao_prototipo_armacao.html](05_gis_mapas/pagina_impressao_prototipo_armacao.html) - página de apoio para impressão
- [01_planejamento/FORMULARIO_CHECKLIST_PROTOTIPO_TEMPORAL_MACROALGAS.html](01_planejamento/FORMULARIO_CHECKLIST_PROTOTIPO_TEMPORAL_MACROALGAS.html) - formulário interativo do checklist (versão web)
- [01_planejamento/LISTA_COMPRAS_SUPRIMENTOS_CAMPO.html](01_planejamento/LISTA_COMPRAS_SUPRIMENTOS_CAMPO.html) - lista de compras e suprimentos de campo

**Produtos criados nesta etapa**

Esta página centraliza os produtos locais montados para o protótipo: o mapa com seis pontos e camadas metodológicas, a página em abas com introdução, ficha e app de campo, o guia de uso e validação, e o dashboard clonado com os resultados dos seis locais. O app de campo já foi testado com sincronização entre abas e entre dispositivos, além de manter operação offline-first.

- Abrir metodologia e ficha de campo: [01_planejamento/metodologia_prototipo_macroalgas.html](01_planejamento/metodologia_prototipo_macroalgas.html)
- Abrir app de campo: [03_formularios/app_campo_macroalgas.html](03_formularios/app_campo_macroalgas.html)
- Guia de uso do app: [03_formularios/GUIA_USO_APP_CAMPO.html](03_formularios/GUIA_USO_APP_CAMPO.html)
- Lista de compras/suprimentos: [01_planejamento/LISTA_COMPRAS_SUPRIMENTOS_CAMPO.html](01_planejamento/LISTA_COMPRAS_SUPRIMENTOS_CAMPO.html)

Link público do produto (inserir somente após validação): https://caetanoronan.github.io/Prototipo-Temporal-de-Macroalgas-Baias-da-Ilha-de-Santa-Catarina/

## Uso em campo

O app de campo é offline-first: ele grava estações, quadrados, rascunhos e preferências no navegador do aparelho usado durante a campanha e envia os dados para a nuvem quando o comando de sincronização é acionado. O fluxo validado permite continuar coletando sem internet e depois baixar ou reenviar os dados em outro aparelho, mantendo o backup local como contingência.

Se houver troca de aparelho, exporte o JSON no aparelho antigo e importe-o no novo antes de seguir com a coleta. Quando a conexão estiver disponível, o app também pode sincronizar entre abas e dispositivos diferentes via Supabase.

## Validação recente

- Sincronização validada entre duas abas abertas no navegador.
- Sincronização validada entre navegador do computador e navegador do celular.
- Upload e download da nuvem funcionando sem erro de chave estrangeira.

## Como reproduzir este protótipo

1. Clone o repositório e abra a pasta raiz no VS Code.
2. Publique o site no GitHub Pages ou abra `index.html` localmente para navegação interna.
3. Abra a metodologia em [01_planejamento/metodologia_prototipo_macroalgas.html](01_planejamento/metodologia_prototipo_macroalgas.html) para consultar o desenho do campo, a aba do app e a ficha.
4. Use [03_formularios/app_campo_macroalgas.html](03_formularios/app_campo_macroalgas.html) para coletar os dados de campo no navegador.
5. Consulte [03_formularios/GUIA_USO_APP_CAMPO.html](03_formularios/GUIA_USO_APP_CAMPO.html) antes de sair para campo e depois de voltar para validar exportação, sincronização e backup.
6. Abra o mapa operacional em [05_gis_mapas/mapa_prototipo_armacao_clone.html](05_gis_mapas/mapa_prototipo_armacao_clone.html) para revisar as camadas de campo e os seis pontos de estudo.
7. Abra o mapa infra em [05_gis_mapas/mapa_prototipo_armacao_infra_clone.html](05_gis_mapas/mapa_prototipo_armacao_infra_clone.html) para gerar PNG com o render local.
8. Se houver internet, teste o envio para a nuvem em mais de uma aba ou em um segundo dispositivo.
9. Após validar em campo, registre os ajustes necessários na documentação e mantenha o backup JSON como contingência.

## Organização da pasta

A pasta principal já está separada por função: planejamento, sops, formulários, dados, mapas, API, infra, render e assets. Isso facilita manter o fluxo do protótipo sem misturar documentação, aplicativo, mapas e backend.

## Exportação PNG

O fluxo de exportação PNG está publicado em nuvem e também pode ser executado localmente, se necessário. No uso normal, o mapa infra aponta para o serviço Render já publicado e gera a imagem com alinhamento cartográfico estável.

Passo a passo local:

1. Instale as dependências do diretório [render](render).
2. Inicie o servidor de render em modo local.
3. Abra [05_gis_mapas/mapa_prototipo_armacao_infra_clone.html](05_gis_mapas/mapa_prototipo_armacao_infra_clone.html) no navegador ou deixe o servidor apontar para ele.
4. Selecione as camadas e referências desejadas.
5. Exporte o PNG e confira se a composição final corresponde aos pontos finais do estudo.

Endpoint oficial em produção:

- [Render live](https://prototipo-temporal-de-macroalgas-baias.onrender.com)
- [Health check](https://prototipo-temporal-de-macroalgas-baias.onrender.com/health)
- [PNG direto](https://prototipo-temporal-de-macroalgas-baias.onrender.com/render.png?layers=quadrat_photo&ref=&base=osm&filename=teste)

## Protocolo operacional

Para operação diária, validação e contingência, consulte:

- [01_planejamento/PROTOCOLO_OPERACAO_EXPORTACAO_PNG.md](01_planejamento/PROTOCOLO_OPERACAO_EXPORTACAO_PNG.md)
- [01_planejamento/PROTOCOLO_OPERACAO_CAMPO_1_PAGINA.md](01_planejamento/PROTOCOLO_OPERACAO_CAMPO_1_PAGINA.md)
- [01_planejamento/OPERACAO_CAMPO_RAPIDA.html](01_planejamento/OPERACAO_CAMPO_RAPIDA.html)

## Autoria e programa

Projeto de Mestrado - PPGOceano/UFSC - 2026
Autor: Ronan Armando Caetano  
Programa: Pós-Graduação em Oceanografia (PPGOceano/UFSC) / CAPES
