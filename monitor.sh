#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Eroare: Te rog specifica un fisier de log."
    echo "Utilizare: $0 <fisier_log>"
    exit 1
fi

LOG_FILE=$1

if [ ! -f "$LOG_FILE" ]; then
    echo "Eroare: Fisierul '$LOG_FILE' nu a fost gasit!"
    exit 1
fi

echo "Se analizeaza fisierul: $LOG_FILE"

ERRORS=$(grep -ic "ERROR" "$LOG_FILE")
WARNINGS=$(grep -ic "WARNING" "$LOG_FILE")

echo "--------------------------------"
echo "Sumar Analiza Loguri:"
echo "Erori gasite: $ERRORS"
echo "Avertismente gasite: $WARNINGS"
echo "--------------------------------"

if [ "$ERRORS" -gt 0 ]; then
    echo "Ultimele erori detectate:"
    grep -i "ERROR" "$LOG_FILE" | tail -n 3
fi

echo ""
echo "=== Monitorizare Resurse Sistem ==="

DISK_USAGE=$(df -h / | grep / | awk '{ print $5 }' | sed 's/%//')

echo "Utilizare Disc: $DISK_USAGE%"

if [ "$DISK_USAGE" -gt 80 ]; then
    echo "ALERTA: Spatiul pe disc este critic!"
else
    echo "Spatiul pe disc este in parametri optimi."
fi

FREE_MEM=$(free -m | grep Mem | awk '{ print $4 }')
echo "Memorie RAM libera: ${FREE_MEM}MB"

if [ "$FREE_MEM" -lt 100 ]; then
    echo "WARNING: Memorie RAM insuficienta!"
fi