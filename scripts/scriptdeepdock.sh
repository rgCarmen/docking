#!/bin/bash

# docker run -it -v ~/docking/data_sets/astex_diverse_set:/astex_diverse_set -v ~/docking/scripts/docking.py:/DeepDock/docking.py -v ~/docking/scripts/scriptdeepdock.sh:/DeepDock/scriptdeepdock.sh omendezlucio/deepdock:latest  cd DeepDock ./scriptdeepdock.sh
# docker run -it -v ~/docking/data_sets/posebusters_benchmark_set:/posebusters_benchmark_set -v ~/docking/scripts/docking.py:/DeepDock/docking.py -v ~/docking/scripts/scriptdeepdock.sh:/DeepDock/scriptdeepdock.sh omendezlucio/deepdock:latest

SET="posebusters_benchmark_set"
INPUT_DIR="../posebusters_benchmark_set"

echo $INPUT_DIR

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