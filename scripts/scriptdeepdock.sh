#!/bin/bash

# docker run -it -v ~/docking/data_sets/astex_diverse_set:/astex_diverse_set -v ~/docking/scripts/docking.py:/DeepDock/docking.py -v ~/docking/scripts/scriptdeepdock.sh:/DeepDock/scriptdeepdock.sh omendezlucio/deepdock:latest  cd DeepDock ./scriptdeepdock.sh
# docker run -it -v ~/docking/data_sets/posebusters_benchmark_set:/posebusters_benchmark_set -v ~/docking/scripts/docking.py:/DeepDock/docking.py -v ~/docking/scripts/scriptdeepdock.sh:/DeepDock/scriptdeepdock.sh omendezlucio/deepdock:latest

help() {
    echo "Uso: $0 <set> <input_dir>"
    echo
    echo "Parámetros:"
    echo "  set         Nombre del conjunto de docking (por ejemplo, posebusters_benchmark_set)."
    echo "  input_dir   Ruta al directorio donde están las carpetas de los complejos."
    echo
    echo "Ejemplo:"
    echo "  $0 posebusters_benchmark_set ../posebusters_benchmark_set"
    exit 0
}



if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    help
fi

if [ $# -lt 2 ]; then
    echo "ERROR: Faltan argumentos. Usa --help para más información."
    exit 1
fi

SET=$1
INPUT_DIR=$2
if [ ! -d "$INPUT_DIR" ]; then
    echo "ERROR: La ruta de entrada no existe -> $INPUT_DIR"
    exit 1
fi


echo "Ejecutando DeepDock..."
for P in "$INPUT_DIR"/*/; do

    BASE=$(basename "$P")
    echo "Complejo" $BASE

    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand_start_conf"
    if ! ls "${LIGAND}_start_conf.mol2" 1> /dev/null 2>&1;then
        obabel "${LIGAND}.sdf" -O "${LIGAND}.mol2" -h

    fi
    
    SDF="$INPUT_DIR/${BASE}/${BASE}_ligand_opt_start_deepdock.sdf"

    #EJECUCIÓN del modelo de DeepDock
    python docking.py $BASE $SET
    #eliminar los ficheros creados durante la ejecución
    rm $BASE*
    fi
done