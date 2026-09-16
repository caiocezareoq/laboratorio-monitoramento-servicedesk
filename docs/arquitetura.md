# Arquitetura do Laboratório

## Visão geral

O laboratório foi desenvolvido para reproduzir um fluxo básico de
monitoramento de infraestrutura e gerenciamento de incidentes.

A arquitetura utiliza um servidor Linux monitorado pelo Zabbix Agent.
O Zabbix identifica alterações nos recursos monitorados e gera
problemas quando os valores ultrapassam os limites definidos nas
triggers.

Após a identificação do problema, o incidente é registrado
manualmente no GLPI para simulação do processo de atendimento de
Service Desk.

## Componentes

### SRV-APP-01

Servidor Linux utilizado como alvo dos testes de monitoramento.

Os principais recursos avaliados são:

- CPU;
- Memória;
- Armazenamento;
- Atividade de I/O.

### Zabbix Agent

Instalado no servidor `SRV-APP-01`.

O agente coleta informações do sistema operacional e disponibiliza
essas métricas para o Zabbix Server.

### Zabbix Server

Responsável pelo recebimento e processamento das métricas coletadas
pelo agente.

Também é responsável pela avaliação das triggers e geração dos
problemas de monitoramento.

### GLPI

Utilizado para gerenciamento dos incidentes.

No laboratório, o GLPI é utilizado para:

- Registro de chamados;
- Categorização;
- Definição de prioridade;
- Triagem;
- Diagnóstico;
- Registro de tarefas;
- Registro da solução;
- Encerramento.

### Docker

Os componentes do laboratório são executados utilizando containers
Docker, facilitando a instalação e a reprodução do ambiente.

## Fluxo operacional

```text
┌───────────────────┐
│    SRV-APP-01     │
│      Linux        │
└─────────┬─────────┘
          │
          │ Métricas
          ▼
┌───────────────────┐
│   Zabbix Agent    │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│   Zabbix Server   │
│                   │
│ Items + Triggers  │
└─────────┬─────────┘
          │
          │ Problem
          ▼
┌───────────────────┐
│       GLPI        │
│                   │
│      Ticket       │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│ Triagem / Análise │
│ Diagnóstico       │
│ Intervenção       │
│ Solução           │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│     Fechamento    │
└───────────────────┘
