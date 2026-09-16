#!/bin/bash

echo "Iniciando teste de carga de CPU..."
echo "Duração: 120 segundos"

stress-ng --cpu 12 --timeout 120s

echo "Teste de CPU finalizado."
