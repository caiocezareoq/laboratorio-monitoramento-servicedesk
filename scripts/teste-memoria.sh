#!/bin/bash

echo "Iniciando teste de carga de memória..."
echo "Duração: 120 segundos"

stress-ng --vm 1 --vm-bytes 6.5G --vm-keep --timeout 120s

echo "Teste de memória finalizado."
