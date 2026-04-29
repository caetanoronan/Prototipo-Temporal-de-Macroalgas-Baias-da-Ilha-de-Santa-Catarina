# Alinhamento do Prototipo de Campo

Data: 2026-04-21
Projeto: Mestrado - Macrofitas Marinhas SC

## Status de etapa concluida (2026-04-24)
- [x] Etapa de Operacao Remota validada com sucesso.

### Evidencias de validacao
- Exportacao PNG executada com sucesso em dispositivo movel (celular).
- Mapa publico ativo no GitHub Pages, com acesso externo.
- Fluxo de render cloud ativo no Render para exportacao de PNG.
- Protocolo operacional completo publicado.
- Protocolo rapido de campo (1 pagina) publicado.
- Pagina HTML mobile com acoes de um toque publicada.

### Resultado operacional
O prototipo passou a operar em modo remoto, permitindo impressao/exportacao de mapas com pontos em qualquer local com internet, sem dependencia do computador local do autor.

## Objetivo deste prototipo
Validar, em pequena escala, o fluxo completo de campo -> controle de qualidade -> organizacao de dados -> produtos cartograficos, antes da campanha principal.

## Base metodologica identificada (Notion publico)
- Estrutura central com Metodologia (master), SOPs, Banco de dados/dicionario, e Planejamento de campo.
- Convencao de geoprocessamento com CRS padrao e rastreabilidade por scripts.
- Separacao entre dados brutos (imutaveis) e dados processados.

## O que falta alinhar (prioridade alta)
- [ ] Definir recorte exato do prototipo (locais, numero de pontos, janela temporal).
- [ ] Fechar variaveis obrigatorias da coleta (bioticas, abioticas, metadados de esforco).
- [ ] Congelar versao 1 do formulario de campo.
- [ ] Consolidar SOP minimo para coleta, foto, georreferenciamento e nomeacao de arquivos.
- [ ] Definir padrao unico de nomes de arquivos e IDs de amostra.
- [ ] Definir regra de QA/QC de entrada (campos obrigatorios, faixas validas, codigos).
- [ ] Definir CRS oficial do projeto para esta fase do prototipo.

## Entregaveis minimos do prototipo
- [ ] 1 formulario de campo operacional (digital ou planilha padronizada).
- [ ] 1 SOP resumido para equipe de coleta.
- [ ] 1 lote de dados-teste com metadados completos.
- [ ] 1 mapa de validacao com pontos amostrais e atributos basicos.
- [ ] 1 relatorio curto de inconsistencias e ajustes para a fase seguinte.

## Estrutura criada nesta pasta
- 01_planejamento
- 02_sops
- 03_formularios
- 04_dados_campo/raw
- 04_dados_campo/processed
- 05_gis_mapas
- 06_logs_validacao

## Proximo ciclo sugerido (48h)
1. Definir o recorte espacial e os pontos piloto.
2. Fechar versao v0.1 do formulario em 03_formularios.
3. Escrever SOP enxuto em 02_sops.
4. Executar coleta simulada com 5 a 10 registros.
5. Rodar QA/QC inicial e registrar ajustes em 06_logs_validacao.

## Perguntas-chave para destravar
- Quais habitats e marcos de referencia entram no piloto?
- Quais variaveis sao essenciais para responder a hipotese principal?
- Quem valida os dados antes de subir para o repositiorio central?
- Qual criterio define que o prototipo esta aprovado para escalar?
