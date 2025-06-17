#!/bin/bash
 # docker run -it -p 8888:8888 -v ~/docking/data_sets/astex_diverse_set:/astex_diverse_set -v ~/docking/scripts/docking.py:/DeepDock/docking.py -v ~/docking/scripts/scriptdeepdock.sh:/DeepDock/scriptdeepdock.sh o
#mendezlucio/deepdock:latest  cd DeepDock ./scriptdeepdock.sh

# docker run -it -p 8888:8888 -v ~/docking/data_sets/posebusters_benchmark_set:/posebusters_benchmark_set -v ~/docking/scripts/docking.py:/DeepDock/docking.py -v ~/docking/scripts/scriptdeepdock.sh:/DeepDock/scriptdeepdock.sh omendezlucio/deepdock:latest
#INPUT_DIR="../astex_diverse_set"
INPUT_DIR="../posebusters_benchmark_set"
echo $INPUT_DIR

echo "Ejecutando DeepDock..."
for P in "$INPUT_DIR"/*/; do

    BASE=$(basename "$P")
    echo "Protein" $BASE

    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand"
    #if ! ls "${LIGAND}.mol2" 1> /dev/null 2>&1;then
        #obabel "${LIGAND}.sdf" -O "${LIGAND}.mol2" -h

    #fi
    SDF="$INPUT_DIR/${BASE}/${BASE}_ligand_opt_deepdock.sdf"
    if [ -f "$SDF" ]; then
        echo "Docking ya existe"
    else
        if [[ "$BASE">"7Q19_DMS" ]]; then
            #echo "yes"
            python docking.py $BASE
        #remove created files
            rm $BASE*
        else
            echo "no"
        fi
    fi

    
    #bust
done