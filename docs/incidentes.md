# Incidentes de Infraestrutura

Este documento apresenta os incidentes simulados no laboratório,
utilizando o Zabbix para detecção e o GLPI para registro e tratamento.

## 1. Alto consumo de CPU

### Detecção

O Zabbix identificou utilização elevada de CPU no servidor `SRV-APP-01`.

Trigger utilizada:

`avg(/SRV-APP-01/system.cpu.util,1m)>90`

### Tratamento

O incidente foi registrado no GLPI e passou pelas etapas de:

- Triagem
- Diagnóstico
- Identificação do processo responsável
- Intervenção
- Validação
- Encerramento

---

## 2. Alto consumo de memória

### Detecção

O Zabbix identificou utilização elevada de memória no servidor
`SRV-APP-01`.

Trigger utilizada:

`avg(/SRV-APP-01/vm.memory.util,1m)>80`

### Tratamento

O incidente foi registrado no GLPI e tratado por meio de:

- Triagem
- Diagnóstico
- Identificação do processo responsável
- Intervenção
- Validação
- Encerramento

---

## 3. Alta utilização de disco

### Detecção

O Zabbix identificou alta utilização do dispositivo de armazenamento
`/dev/sdd`.

Trigger utilizada:

`avg(/SRV-APP-01/vfs.dev.util[sdd],1m)>80`

### Tratamento

O incidente foi registrado no GLPI e tratado por meio de:

- Triagem
- Diagnóstico
- Identificação da atividade de I/O
- Intervenção
- Validação
- Encerramento
