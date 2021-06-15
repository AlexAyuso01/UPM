 #! /bin/bash


# FICHERO CON UN SOLO ARGUMENTO
if [ $# -ne 1 ]; then
    echo "minientrega.sh: Error(EX_USAGE), uso incorrecto del mandato. "Success"" 1>&2
    echo "minientrega.sh: <<descripción detallada del error>>" 1>&2
    exit 64
fi

# HELP 
if [[ $1 == "-h" || $1 == "--help" ]]; then
    echo "minientrega.sh: Uso: minientrega.sh ID_PRACTICA"
    echo "minientrega.sh: copia una practica en un directorio de entrega"
    exit 0
fi 

# DIRECTORIO BUENO??  

if [[ ! -d $MINIENTREGA_CONF ]]; then 
    echo "minientrega.sh: Error, no se pudo realizar la entrega" 1>&2
    echo "minientrega.sh+ no es accesible el directorio \""$MINIENTREGA_CONF"\"" 1>&2 
    exit 64
fi

# COMPROBAMOS VALIDEZ DEL ARCHIVO
ID_PRACTICA="$MINIENTREGA_CONF/$1"

if [[ ! -f $ID_PRACTICA ]]; then
    echo "minientrega.sh: Error, no se pudo realizar la entrega" 1>&2
    echo "minientrega.sh+ no es accesible el fichero \"$1\"" 1>&2
    exit 64
fi

# CARGAMOS VARIABLE
source $ID_PRACTICA

# ARCHIVOS.... 

# BUCLE VE VALIDEZ DE ARCHIVOS

for FILE in $MINIENTREGA_FICHEROS; do
    if [ ! -r $FILE ]; then
        echo "minientrega.sh: Error, no se pudo realizar la entrega" 1>&2
        echo "minientrega.sh+ no es accesible el fichero "$FILE"" 1>&2
        exit 66
    fi
done

FICHERO="$MINIENTREGA_DESTINO/${USER}"

# HACEMOS LA ENTREGA

if [ ! -d $MINIENTREGA_DESTINO ] || ! mkdir -p "$FICHERO" >/dev/null 2>&1 ; then
    echo "minientrega.sh: Error, no se pudo realizar la entrega" 1>&2
    echo "minientrega.sh+ no se pudo crear el subdirectorio de entrega en "$MINIENTREGA_DESTINO"" 1>&2
    exit 73
fi

# METEMOS LOS ARCHIVOS EN SU DIRECTORIO
for FILE in $MINIENTREGA_FICHEROS; do
    cp $FILE "$FICHERO"
done

#SI SE LLEGA AQUI -> TODO OK -> SALIDA 0
exit 0

####FIN####
