# Laboratório de Service Desk e Monitoramento

Laboratório prático desenvolvido para simular atividades de **Service Desk,
monitoramento de infraestrutura e gerenciamento de incidentes**, utilizando
Zabbix, GLPI, Linux e Docker.

## Objetivos

- Monitorar um servidor Linux;
- Identificar alterações no uso de recursos de infraestrutura;
- Configurar triggers no Zabbix;
- Detectar incidentes de forma automatizada pelo monitoramento;
- Registrar incidentes no GLPI;
- Realizar triagem e diagnóstico;
- Registrar procedimentos de intervenção;
- Documentar soluções e encerramento de chamados.

## Arquitetura

```text
                         ┌─────────────────┐
                         │   SRV-APP-01    │
                         │      Linux      │
                         └────────┬────────┘
                                  │
                            Zabbix Agent
                                  │
                                  ▼
                         ┌─────────────────┐
                         │     Zabbix      │
                         │   Monitoramento │
                         └────────┬────────┘
                                  │
                           Problem / Alert
                                  │
                                  ▼
                         ┌─────────────────┐
                         │      GLPI       │
                         │     Ticket      │
                         └────────┬────────┘
                                  │
                    ┌─────────────┴─────────────┐
                    ▼                           ▼
                Diagnóstico                Intervenção
                    │                           │
                    └─────────────┬─────────────┘
                                  ▼
                              Solução
                                  │
                                  ▼
                              Fechamento



