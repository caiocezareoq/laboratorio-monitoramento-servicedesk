#!/bin/bash

echo "Iniciando teste de I/O de disco..."
echo "Duração: 120 segundos"

stress-ng --io 4 --hdd 2 --hdd-bytes 2G --timeout 120s

echo "Teste de disco finalizado."
