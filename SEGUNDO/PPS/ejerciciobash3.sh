#!/bin/bash

dir1=$1
dir2=$2

# Obtenemos los archivos en ambos directorios
files1=$(find "$dir1" -type f -not -name ".*")
files2=$(find "$dir2" -type f -not -name ".*")

# Comparamos los archivos en ambos directorios
for file1 in $files1; do
  # Obtenemos el nombre del archivo sin el directorio
  name1=$(basename "$file1")
  # Buscamos el archivo con el mismo nombre en el segundo directorio
  file2=$(find "$dir2" -type f -not -name ".*" -name "$name1")
  if [ -z "$file2" ]; then
	echo "El fichero \"$name1\" de \"$dir1\" no es un \"regular file\" de \"$dir2\"" >&2
	exit=-1
  else
	# Comparamos los archivos
	diff -q "$file1" "$file2" > /dev/null
	if [ $? -ne 0 ]; then
  	echo "Los ficheros \"$name1\" de \"$dir1\" y \"$dir2\" no son iguales" >&2
  	exit=-1
	fi
  fi
done

# Comparamos los archivos en el segundo directorio que no están en el primer directorio
for file2 in $files2; do
  name2=$(basename "$file2")
  file1=$(find "$dir1" -type f -not -name ".*" -name "$name2")
  if [ -z "$file1" ]; then
	echo "El fichero \"$name2\" de \"$dir2\" no es un \"regular file\" de \"$dir1\"" >&2
	exit=-1
  fi
done

exit $exit
