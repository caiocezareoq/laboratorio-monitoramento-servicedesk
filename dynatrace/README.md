# Dynatrace no laboratório de monitoramento

Laboratório para aprender Dynatrace na prática, usando o mesmo ambiente que eu já monitorava com Zabbix e GLPI. Realizado entre outubro e novembro de 2026, no trial gratuito (SaaS).

## Ambiente

| Item | Configuração |
|---|---|
| Host monitorado | Ubuntu no WSL (PC-CAIO), 12 núcleos |
| Serviços no host | Zabbix, GLPI e MySQL em Docker Compose |
| Plataforma | Dynatrace SaaS (trial de 15 dias) |
| Agente | OneAgent 1.347 em modo Full-Stack |
| Geração de carga | stress-ng |

## O que foi feito

1. Instalação do OneAgent e descoberta automática de processos e containers
2. Teste de saturação de CPU e análise do problema gerado
3. Teste de memória com ajuste do limite de anomalia
4. Dashboard em DQL com CPU e memória
5. Notificação de problemas via workflow e webhook HTTP

## 1. Instalação do OneAgent

Instalado pelo instalador Linux, em modo Full-Stack:

```bash
sudo /bin/sh Dynatrace-OneAgent-Linux-x86-<versão>.sh --set-monitoring-mode=fullstack --set-app-log-content-access=true
sudo systemctl status oneagent
```

Depois de reiniciar os containers do laboratório, o Dynatrace passou a mostrar sozinho os processos (Zabbix server, MySQL), os containers e as conexões entre eles, sem nenhum cadastro manual.

**Problema encontrado:** a primeira execução falhou por falta de privilégio de root (`Error: Process root access: false`). Resolvido rodando o instalador com `sudo`.

![Host no Dynatrace](prints/01-host.png)
![Processos descobertos](prints/02-processos.png)

## 2. Teste de saturação de CPU

```bash
stress-ng --cpu 0 --cpu-load 100 --timeout 15m
```

| Item | Resultado |
|---|---|
| Problema gerado | CPU Saturation (Resource contention), aberto automaticamente |
| Regra padrão | CPU acima de 95% em 18 de 30 amostras de 10 segundos (cerca de 3 minutos) |
| Tempo até a abertura | <preencher: minutos entre o início do teste e a abertura> |
| Fechamento | Automático após o fim da carga; em outro teste, fechado manualmente com comentário de causa, ação e resultado |
| Causa raiz no Davis | "No root cause": o teste só envolvia infraestrutura, sem serviços dependentes para correlacionar |
| Causa identificada | Processo stress-ng no topo do consumo de CPU, na aba de processos do host |

![Problema de CPU](prints/03-problema-cpu.png)

## 3. Teste de memória e ajuste do limite

O alerta padrão de memória no Linux exige **duas condições ao mesmo tempo**: uso acima de 80% **e** mais de 20 page faults por segundo, em 18 de 30 amostras.

Para validar a detecção, ajustei o limite no nível do host para uso acima de 60% e page faults acima de 1/s:

```bash
stress-ng --vm 1 --vm-bytes 75% --timeout 10m
stress-ng --vm 1 --vm-bytes 75% --fault 2 --timeout 10m
```

| Métrica | Resultado |
|---|---|
| Uso de memória | Entre 55% e 75% (acima do limite em boa parte do teste) |
| Page faults | No máximo 0,02/s (abaixo do limite de 1/s) |
| Alerta | Não disparou |

**Conclusão:** o alerta não disparou porque a segunda condição nunca foi cumprida. O stress-ng gera quase só page faults leves, e o WSL não gerou os page faults graves que a métrica considera. Esse comportamento é intencional: evita alarmes falsos quando a memória está ocupada sem afetar o desempenho. Ao final, o limite voltou para o modo automático.

![Memória e page faults](prints/04-memoria-page-faults.png)

## 4. Dashboard em DQL

Dashboard "Lab – Infraestrutura" com dois gráficos:

```sql
// Uso de CPU por host (%)
timeseries cpu = avg(dt.host.cpu.usage), by: {dt.smartscape.host}
```

```sql
// Uso de memória por host (%)
timeseries mem = avg(dt.host.memory.usage), by: {dt.smartscape.host}
```

Os gráficos mostram os testes em sequência: o pico de memória com CPU em torno de 9% (só `--vm`), depois em torno de 28% (com `--fault`), e o pico de CPU em 100%.

![Dashboard](prints/05-dashboard.png)

## 5. Notificação de problemas

Workflow com **Problem trigger** (problemas ativos ou fechados, todas as categorias).

**Tentativa 1: e-mail.** Não funcionou. O envio retornou erro 403, porque a ação de e-mail só está liberada em ambientes pagos ou de prova de conceito, não no trial.

Problemas encontrados no caminho:

| Erro | Causa | Solução |
|---|---|---|
| `At least one of the properties entityTags, names or customFilter needs to be provided` | Gatilho "Davis event" exige filtro | Troquei para o "Problem trigger" |
| Gatilho filtrando só "availability" | CPU Saturation é da categoria "Resource contention" | Selecionei todas as categorias |
| Workflow não executava | Faltava autorizar o Dynatrace a rodar workflows em nome do usuário | Autorização concedida no primeiro "Run" |
| Erro 403 no e-mail | Limitação de licença do trial | Troquei por webhook HTTP |

**Tentativa 2: webhook HTTP.** Ação HTTP Request (POST) enviando os dados do problema:

```json
{
  "status": "{{ event()['event.status'] }}",
  "problema": "{{ event()['display_id'] }}",
  "nome": "{{ event()['event.name'] }}",
  "categoria": "{{ event()['event.category'] }}"
}
```

Resultado recebido no webhook:

```json
{
  "status": "CLOSED",
  "problema": "P-26112",
  "nome": "CPU Saturation",
  "categoria": "RESOURCE_CONTENTION"
}
```

![Workflow](prints/06-workflow.png)
![Webhook recebido](prints/07-webhook.png)

## Zabbix x Dynatrace

| | Zabbix | Dynatrace |
|---|---|---|
| Descoberta | Hosts, itens e triggers cadastrados manualmente | Automática pelo OneAgent (processos, containers e conexões) |
| Alertas | Triggers com limites definidos por mim | Limites padrão prontos, ajustáveis por host, e opção de limite adaptativo |
| Causa raiz | Análise manual | Correlação automática pelo Davis (mais útil quando há serviços dependentes) |
| Consultas e painéis | Dashboards e gráficos da ferramenta | Dashboards com DQL |
| Notificação | Actions e media types | Workflows (e-mail exige licença paga; webhook funciona no trial) |
| Custo | Open source | Licença paga |

## Aprendizados

- O alerta de memória considera impacto real (page faults), não só memória ocupada.
- "No root cause" não é falha: a correlação depende de haver serviços e dependências monitorados.
- Workflows precisam de autorização explícita para executar em nome do usuário.
- Recursos do trial têm limitações de licença; o webhook HTTP é uma alternativa para integrar com outras ferramentas.
- Agentes de monitoramento consomem recursos: por isso não instalei o OneAgent no ambiente de experimentos do meu TCC.
