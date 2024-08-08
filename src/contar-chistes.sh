#!/bin/bash

# Función para mostrar la ayuda
function mostrar_ayuda {
  echo "Uso: $0 -t TIEMPO -f ARCHIVO"
  echo ""
  echo "Opciones:"
  echo "  -t TIEMPO      Especifica el tiempo de espera en segundos entre chistes (debe ser entre 1 y 120 segundos)."
  echo "  -f ARCHIVO     Especifica la ruta del archivo que contiene los chistes."
  echo "  -h, --help     Muestra esta ayuda y termina."
  echo ""
  echo "Ejemplo:"
  echo "  $0 -t 2 -f chistes.txt       Muestra un chiste cada 2 segundos usando el archivo chistes.txt."
}

# Verificar si no se han pasado parámetros
if [ $# -eq 0 ]; then
  mostrar_ayuda
  exit 1
fi

# Variables para almacenar parámetros
tiempo=""
archivo=""

# Parsear los argumentos
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -t) tiempo="$2"; shift ;;
    -f) archivo="$2"; shift ;;
    -h|--help) mostrar_ayuda; exit 0 ;;
    *) echo "Opción desconocida: $1"; mostrar_ayuda; exit 1 ;;
  esac
  shift
done

# Verificar que el tiempo se ha establecido y es válido
if [[ -z "$tiempo" ]]; then
  echo "Error: Debes especificar el tiempo de espera con -t."
  mostrar_ayuda
  exit 1
elif ! [[ "$tiempo" =~ ^[0-9]+$ ]] || [ "$tiempo" -lt 1 ] || [ "$tiempo" -gt 120 ]; then
  echo "Error: El tiempo de espera debe ser un número entre 1 y 120 segundos."
  mostrar_ayuda
  exit 1
fi

# Verificar que el archivo se ha establecido y existe
if [[ -z "$archivo" ]]; then
  echo "Error: Debes especificar la ruta del archivo de chistes con -f."
  mostrar_ayuda
  exit 1
elif [ ! -f "$archivo" ]; then
  echo "Error: El archivo especificado no existe."
  exit 1
fi

# Función para obtener una línea aleatoria del archivo
function chiste_aleatorio {
  # Contar el número de líneas en el archivo
  lineas=$(wc -l < "$archivo")
  # Generar un número aleatorio entre 1 y el número de líneas
  numero_aleatorio=$(shuf -i 1-$lineas -n 1)
  # Obtener la línea correspondiente y mostrarla
  sed -n "${numero_aleatorio}p" "$archivo"
}

# Bucle infinito
while true; do
  # Llamar a la función y mostrar el chiste
  chiste_aleatorio
  # Esperar el tiempo especificado
  sleep "$tiempo"
done
