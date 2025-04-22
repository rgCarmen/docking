#Esto habría que meterlo en el otro script

#!/bin/bash

# Configuración de archivos y rutas


INPUT_DIR="../data_sets/astex_diverse_set"
OUT_DIR="../results"


OUT_FORMAT="csv"


echo "Procesando resultados con bust..."

 for P in "$INPUT_DIR"/*/; do

    BASE=$(basename "$P")


    PROTEIN="${INPUT_DIR}/${BASE}/${BASE}_protein.pdb"
    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand.sdf"
    SDF="${INPUT_DIR}/${BASE}/${BASE}_ligand_opt_deepdock.sdf"
    

    if [ -f "$SDF" ]; then
        echo $BASE

        bust "$SDF" -l "$LIGAND" -p "$PROTEIN" --outfmt ""$OUT_FORMAT  | awk -v protein="$BASE" 'NR>1 {print protein "," $0}'>> $OUT_DIR/resultsBustDeepDock.csv
    fi
done

echo "Ejecución terminada"