#!  /usr/bin/bash

#COMPRUEBO QUE SE LLAMA A UN FICHERO CON UN UNICO ARGUMENTO
if [ $# -ne 1 ]
    then
        echo "minientrega.sh: Error(EX_USAGE), uso incorrecto del mandato. \"Success\" " 1>&2
        echo "minientrega.sh+ Número de argumentos incorrecto " 1>&2
        exit 64
else
#COMPRUEBO QUE SE REALIZA LA SOLICITUD DE AYUDA
    if [ $1 == "-h" ] || [ $1 == "--help" ]

        then
            echo "minientrega.sh: Uso: $0 {nombre_archivo} o -h|--help para la ayuda"
            echo "minientrega.sh: Copia ficheros a entregar de un directorio a otro de entrega"
            exit 0
    fi
fi

#COMPRUEBO SI EL DIRECTORIO ES VALIDO
if [ ! -d $MINIENTREGA_CONF ]
    then
        echo "minientrega.sh: Error, no se pudo realizar la entrega" 1>&2
        echo "minientrega.sh+ no es accesible el directorio \"$MINIENTREGA_CONF\"" 1>&2
        exit 64
fi

#EL ARCHIVO ES VALIDO??
ID_PRACTICA="$MINIENTREGA_CONF/$1"

if [ ! -f $ID_PRACTICA ]
    then
    echo "minientrega.sh: Error, no se pudo realizar la entrega" 1>&2
    echo "minientrega.sh+ no es accesible el fichero \"$1\"" 1>&2
    exit 66
fi

#VARIABLE DEL ARCHIVO
source $ID_PRACTICA

#BUCLE PARA VER SI EL FICHERO ES VALIDO
for FICHERO in ${MINIENTREGA_FICHEROS}; do
        if [ ! -r "$FICHERO" ]
            then
                echo "minientrega.sh: Error, no se pudo realizar la entrega" 1>&2
                echo "minientrega.sh+ no es accesible el fichero \"$MINIENTREGA_FICHEROS\"" 1>&2
                exit 66
        fi
done

ID_PRACTICA="$MINIENTREGA_DESTINO/${USER}"

#ENTREGA
if [ ! -d $MINIENTREGA_DESTINO ] || mkdir -p "$ID_PRACTICA/${USER}" >/dev/null 2>&1
    then
        echo "minientrega.sh: Error, no se pudo realizar la entrega" 1>&2
        echo "minientrega.sh+ no se pudo crear el subdirectorio de entrega en \"$MINIENTREGA_DESTINO\"" 1>&2
        exit 73
fi

#COPIA D ELOS ARCHIVOS AL DIRECTORIO CORRECTO
for FILE in $MINIENTREGA_FICHEROS; do
 cp $FILE "${ID_PRACTICA}/${USER}"
done
#TERMINACION CORRECTA
exit 0
