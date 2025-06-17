#!/bin/bash

# Configuración de archivos y rutas

NUM_PROCESOS=$1

# Activar entorno conda
cd ../../tfg/DiffDock
source ~/miniconda3/etc/profile.d/conda.sh # conda init (no funciona ni idea por que)
conda activate diffdock || { echo "ERROR: No se activó el entorno 'diffdock'."; exit 1; }

python -c "import esm; print(esm.__file__)"

SET="astex_diverse_set"  
 #"astex_diverse_set"/posebusters_benchmark_set
RESULT_NAME="results_astex_diffdock_start"


ASTEX="../astex_diverse_set/astex.txt"

DIR="$HOME/docking/data_sets/$SET"
#ASTEX="$DIR.$SET.txt"
ls -d $DIR/*/ | xargs -n 1 basename > $ASTEX



CONFIG="default_inference_args.yaml"
OUT_CSV_ALL="$HOME/docking/results/$RESULT_NAME/evaluation.csv"

mkdir -p $HOME/docking/results/$RESULT_NAME/temp


procesar_proteina() {

BASE=$1

echo "Protein $BASE"

#PROTEIN="../astex_diverse_set/${BASE}/${BASE}_protein.pdb"
#LIGAND="../astex_diverse_set/${BASE}/${BASE}_ligand.sdf"

PROTEIN="$DIR/${BASE}/${BASE}_protein.pdb"
LIGAND="$DIR/${BASE}/${BASE}_ligand_start_conf.sdf"
LIGAND_TRUE="$DIR/${BASE}/${BASE}_ligand.sdf"

OUT_DIR="$HOME/docking/results/$RESULT_NAME/$BASE"
SDF="$OUT_DIR"/complex_0/rank1.sdf
OUT_FORMAT="csv"


if [ -f "$SDF" ]; then
    echo "Docking ya existe"
else
    # Ejecutar DiffDock
    echo "Ejecutando DiffDock..."
    #echo "LIGAND: $LIGAND"
    python -m inference --config "$CONFIG" --protein_path "$PROTEIN" --ligand "$LIGAND" --out_dir "$OUT_DIR" > /dev/null
    if [ $? -ne 0 ]; then
        echo "ERROR: Falló la ejecución de DiffDock para $BASE"
        rm -rf "$OUT_DIR" #ELIMINAR DIRECTORIO QUE HA CREADO pero esta vacio
        return 1
    fi

fi

# Procesar resultados con bust
echo "Procesando resultados con bust..."


#OUT_CSV="${SDF%.sdf}.csv"


if [ -f "$SDF" ]; then
    bust "$SDF" -l "$LIGAND_TRUE" -p "$PROTEIN" --outfmt "$OUT_FORMAT" | awk -v protein="$BASE" 'NR>1 {print protein "," $0}' > "$HOME/docking/results/$RESULT_NAME/temp/${BASE}.csv"
fi

}

export -f procesar_proteina
export CONFIG OUT_CSV_ALL RESULT_NAME DIR
cat "$ASTEX" | xargs -I {} -P $NUM_PROCESOS bash -c 'procesar_proteina "$@"' _ {}

echo "Concatenando resultados..."
cat "$HOME/docking/results/$RESULT_NAME/temp"/*.csv >> $OUT_CSV_ALL
rm -rf "$HOME/docking/results/$RESULT_NAME/temp"

rm $ASTEX


echo "Ejecución completada."



