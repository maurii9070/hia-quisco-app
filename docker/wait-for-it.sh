#!/bin/sh

# wait-for-it.sh es un script que espera hasta que un servicio específico en una red esté disponible
TIMEOUT=15
QUIET=0

# Imprimir ayuda
usage()
{
    echo "Uso: $0 host:port [-t timeout] [-q] -- command args"
    exit 1
}

# Procesar argumentos
while [ $# -gt 0 ]
do
    case "$1" in
        *:* )
        HOSTPORT="$1"
        shift 1
        ;;
        -t)
        TIMEOUT="$2"
        if [ -z "$TIMEOUT" ]; then usage; fi
        shift 2
        ;;
        -q)
        QUIET=1
        shift 1
        ;;
        --)
        shift
        break
        ;;
        *)
        usage
        ;;
    esac
done

# Verificar que host:port está definido
if [ -z "$HOSTPORT" ]; then
    echo "Error: falta host:port."
    usage
fi

# Extraer host y port
HOST=$(printf "%s\n" "$HOSTPORT"| cut -d : -f 1)
PORT=$(printf "%s\n" "$HOSTPORT"| cut -d : -f 2)

# Función para imprimir mensajes
log() {
    if [ "$QUIET" -ne 1 ]; then
        echo "$@"
    fi
}

# Comando nc espera hasta que el servicio esté disponible
result=1
for i in $(seq $TIMEOUT) ; do
    nc -z "$HOST" "$PORT" > /dev/null 2>&1
    result=$?
    if [ $result -eq 0 ] ; then
        break
    fi
    sleep 1
done

if [ $result -ne 0 ]; then
    log "Tiempo de espera agotado después de ${TIMEOUT} segundos esperando a $HOST:$PORT"
    exit 1
fi

log "$HOST:$PORT está disponible"

exec "$@"
