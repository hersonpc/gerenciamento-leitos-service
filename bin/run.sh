#!/bin/bash

OUTPUT_JSON_1=/app/public/data_scores_enfermagem_hdt.json
OUTPUT_JSON_2=/app/public/data_scores_enfermagem_ceapsol.json

echo "> Parametrizando sistema"

echo "America/Sao_Paulo" > /etc/timezone
export TZ=America/Sao_Paulo

echo
echo "> Busca inicial de dados"
./gth_data_extractor "$OUTPUT_JSON_1" "$OUTPUT_JSON_2"

echo
echo "> Iniciando serviço NodeJS"
node server.js >/dev/null 2>/dev/null &

echo "> Iniciando monitoramento dos dados em ciclos de 60s"
while true
do
    echo
    echo "> Buscando dados em $(date)"
    ./gth_data_extractor "$OUTPUT_JSON_1" "$OUTPUT_JSON_2"
    echo "< Done"
    sleep 60
done