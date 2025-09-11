#!/bin/bash

help() {
    echo "Uso: $0 <input_dir> <out_dir>"
    echo
    echo "Parámetros:"
    echo "  input_dir   Ruta al directorio donde están las carpetas de los complejos."
    echo "  out_dir     Carpeta donde se guardarán los resultados."
    echo
    echo "Ejemplo:"
    echo "  $0 \$HOME/docking/data_sets/posebusters_benchmark_set \$HOME/docking/results"
    exit 0
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    help
fi

if [ $# -lt 2 ]; then
    echo "ERROR: Faltan argumentos. Usa --help para más información."
    exit 1
fi

# Configuración de archivos y rutas

INPUT_DIR=$1

if [ ! -d "$INPUT_DIR" ]; then
    echo "ERROR: La ruta de entrada no existe -> $INPUT_DIR"
    exit 1
fi

OUT_DIR=$2
OUT_FORMAT="csv"

# Ejecución de PoseBusters
echo "Procesando resultados con bust..."

for P in "$INPUT_DIR"/*/; do

    BASE=$(basename "$P")


    PROTEIN="${INPUT_DIR}/${BASE}/${BASE}_protein.pdb"
    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand.sdf"
    SDF="${INPUT_DIR}/${BASE}/${BASE}_ligand_opt_start_deepdock.sdf"
    

    if [ -f "$SDF" ]; then
        echo $BASE

        bust "$SDF" -l "$LIGAND" -p "$PROTEIN" --outfmt "$OUT_FORMAT"  | awk -v protein="$BASE" 'NR>1 {print protein "," $0}'>> $OUT_DIR/resultsBustPBDeepDockStart.csv
    fi

done

echo "Ejecución terminada"