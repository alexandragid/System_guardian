#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

print_header() {
    echo -e "${YELLOW}====================================${NC}"
    echo -e "${YELLOW}   SYSTEM GUARDIAN - RAPORT ZILNIC  ${NC}"
    echo -e "${YELLOW}====================================${NC}"
}

analyze_logs() {
    local FILE=$1
    echo -e "\n${GREEN}[+] Analiza fisierului: $FILE${NC}"
    
    ERRORS=$(grep -ic "ERROR" "$FILE")
    WARNINGS=$(grep -ic "WARNING" "$FILE")
    
    echo "Erori gasite: $ERRORS"
    echo "Avertismente gasite: $WARNINGS"
    
    if [ "$ERRORS" -gt 0 ]; then
        echo -e "${RED}Ultimele 3 erori critice:${NC}"
        grep -i "ERROR" "$FILE" | tail -n 3
    fi
}

check_resources() {
    echo -e "\n${GREEN}[+] Status Resurse Sistem${NC}"
    
    DISK_USAGE=$(df -h / | grep / | awk '{print $5}' | sed 's/%//')
    echo "Utilizare Disc: $DISK_USAGE%"
    
    RAM_FREE=$(free -m | grep Mem | awk '{print $4}')
    echo "Memorie RAM Libera: ${RAM_FREE}MB"
    
    if [ "$DISK_USAGE" -gt 80 ]; then
        echo -e "${RED}!!! ALERTA: Spatiu insuficient pe disc !!!${NC}"
    fi
}

if [ $# -eq 0 ]; then
    echo -e "${RED}Eroare: Lipseste fisierul de log.${NC}"
    echo "Utilizare: $0 <cale_fisier_log>"
    exit 1
fi

LOG_INPUT=$1

if [ ! -f "$LOG_INPUT" ]; then
    echo -e "${RED}Eroare: Fisierul '$LOG_INPUT' nu exista.${NC}"
    exit 1
fi

REPORT_NAME="raport_$(date +%H%M_%d%m).txt"

print_header
analyze_logs "$LOG_INPUT"
check_resources

{
    echo "RAPORT GENERAT LA: $(date)"
    echo "---------------------------"
    
    ERRORS_COUNT=$(grep -ic "ERROR" "$LOG_INPUT")
    echo "Erori in loguri: $ERRORS_COUNT"
    df -h /
    free -m
} > "$REPORT_NAME"

echo -e "\n${YELLOW}Gata! Raportul text a fost salvat in: $REPORT_NAME${NC}"