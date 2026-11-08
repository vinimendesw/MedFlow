# EXP-04: Testes automatizados com Jest (MedFlow)

## Objetivo
Verificar, com testes unitários, uma regra simples de conflito entre alergias
cadastradas e componentes de um medicamento (verificação inicial do RF-010).

## Rodar (PowerShell, dentro da pasta)
1. `npm install`
2. `npm.cmd test`

## Testes (`verificarAlergia.test.js`)
- identifica conflito de alergia;
- identifica ausência de conflito;
- identifica conflito em medicamento composto (contém uma substância registrada como alergia).

## Resultado
1 suíte e 3 testes aprovados (0,777 s). Evidência: `PRINTS/print_jest_pass.png`.

## Limitações
Usa dados simulados e comparação literal de substâncias. Não avalia sinônimos, dosagens,
comorbidades, interações medicamentosas nem integração com API e banco de dados; portanto
não representa a validação integral do RF-010. A consulta com o modelo relacional real foi
feita na EXP-02.
