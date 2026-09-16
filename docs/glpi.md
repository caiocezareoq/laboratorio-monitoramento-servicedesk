# Gerenciamento de Incidentes no GLPI

## Objetivo

O GLPI é utilizado no laboratório para reproduzir um fluxo de
atendimento de incidentes de infraestrutura.

## Fluxo de atendimento

Cada incidente segue as seguintes etapas:

1. Registro do chamado;
2. Classificação;
3. Definição de urgência e impacto;
4. Triagem;
5. Diagnóstico;
6. Execução da tarefa/intervenção;
7. Registro da solução;
8. Validação;
9. Encerramento.

## Categorias utilizadas

O laboratório possui categorias para organização dos chamados:

- Rede;
- Hardware;
- Software;
- Sistema Operacional;
- Acesso;
- Servidor;
- Impressora;
- Monitoramento.

## Incidentes tratados

### Alto consumo de CPU

Incidente identificado pelo Zabbix no servidor `SRV-APP-01`.

O chamado registra a análise dos processos em execução, identificação
da causa, intervenção e validação do retorno da utilização da CPU aos
níveis esperados.

### Alto consumo de memória

Incidente identificado pelo Zabbix após a utilização de memória
ultrapassar o limite configurado.

O chamado registra a análise do consumo de memória, identificação do
processo responsável, intervenção e validação.

### Alta utilização de disco

Incidente identificado pelo Zabbix após a utilização do dispositivo
`sdd` ultrapassar o limite configurado.

O chamado registra a análise da atividade de I/O, identificação da
origem do consumo, intervenção e validação.

## Relação com o monitoramento

O fluxo utilizado no laboratório é:

```text
Zabbix detecta
      ↓
Problema identificado
      ↓
Chamado criado no GLPI
      ↓
Triagem
      ↓
Diagnóstico
      ↓
Intervenção
      ↓
Solução
      ↓
Fechamento
