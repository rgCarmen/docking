# Docking Benchmark Pipeline

Este repositorio contiene scripts y recursos para la evaluación y comparación de diferentes métodos de docking molecular sobre conjuntos de datos de benchmarking como Astex y PoseBusters.

## Estructura del repositorio

```
analysisResults.ipynb
README.txt
data_sets/
    astex_diverse_set/
        ...
    posebusters_benchmark_set/
        ...
results/
    ...
scripts/
    bustdeepdock.sh
    docking.py
    scriptdeepdock.sh
    scriptdiffdock.sh
    scriptequibind.sh
    scriptunimol.sh
    diffdock_parallel.sh
    ...
```

### Descripción de carpetas y archivos

- **analysisResults.ipynb**: Jupiter Notebook para el análisis de los resultados obtenidos de las diferentes herramientas de docking.
- **data_sets/**: Contiene los conjuntos de datos utilizados.
- **results/**: Resultados generados por las diferentes herramientas de docking.
  - Cada subcarpeta corresponde a un método y/o conjunto de datos específico 
  - Dentro de cada subcarpeta hay directorios por complejo con elarchivos SDF resultante.
- **scripts/**: Scripts para ejecutar las diferentes herramientas de docking y procesar los resultados.
  - **DiffDock**: *diffdock_parallel.sh*
  - **EquiBind**: *scriptequibind.sh*
  - **DeepDock**: *scriptdeepdock.sh*, *docking.py*, *bustdeepdock.sh*
  - **UniMol**: *scriptunimol.sh*, *unimol_grid.py*
 

## Herramientas empleadas y Requisitos

- [EquiBind](https://github.com/HannesStark/EquiBind) (acceso: 9 de junio de 2025)  
- [DiffDock](https://github.com/gcorso/DiffDock) (acceso: 15 de abril de 2025)  
- [DeepDock](https://github.com/OptiMaL-PSE-Lab/DeepDock) (acceso: 30 de marzo de 2025)  
- [Uni-Mol Docking V2](https://github.com/deepmodeling/Uni-Mol/tree/main/unimol_docking_v2) (acceso: 27 de abril de 2025)  
---
- Python (con RDKit, PyTorch, y dependencias de cada método)
- Conda (para los entornos de DeepDock, DiffDock, EquiBind, UniMol)
- Repositorios de las herramientas
- PoseBusters y Open Babel para evaluación y conversión de formatos

