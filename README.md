# Laboratório de Service Desk e Monitoramento

Laboratório prático desenvolvido para simular atividades de **Service Desk,
monitoramento de infraestrutura e gerenciamento de incidentes**, utilizando
Zabbix, GLPI, Linux e Docker.

## Competencias Demonstradas

Este projeto demonstra conhecimentos práticos em:

Linux — administração e monitoramento de servidor;
Docker e Docker Compose — implantação e reprodução do ambiente;
Zabbix — coleta de métricas, itens, triggers e identificação de problemas;
GLPI — gerenciamento de chamados e fluxo de atendimento de incidentes;
Service Desk — triagem, diagnóstico, intervenção, registro de solução e encerramento;
Bash — criação de scripts para simulação controlada de incidentes;
Troubleshooting — investigação e resolução de problemas de infraestrutura;
Monitoramento de infraestrutura — acompanhamento de CPU, memória, armazenamento e I/O;
Git e GitHub — versionamento e documentação do projeto.

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

´´´text



