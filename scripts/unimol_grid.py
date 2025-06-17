import json
import numpy as np
import pandas as pd
from tqdm import tqdm
from rdkit import Chem
import os
from typing import Optional 
from rdkit import Chem
import argparse



def calculated_docking_grid_sdf(ligand_file,output_grid, add_size=10):
    add_size = add_size
    mol = Chem.MolFromMolFile(str(ligand_file), sanitize=False)
    coords = mol.GetConformer(0).GetPositions().astype(np.float32)
    min_xyz = [min(coord[i] for coord in coords) for i in range(3)]
    max_xyz = [max(coord[i] for coord in coords) for i in range(3)]
    center = np.mean(coords, axis=0)
    size = [abs(max_xyz[i] - min_xyz[i]) for i in range(3)]
    center_x, center_y, center_z = center
    size_x, size_y, size_z = size
    size_x = size_x + add_size
    size_y = size_y + add_size
    size_z = size_z + add_size
    grid_info = {
        "center_x": float(center_x),
        "center_y": float(center_y),
        "center_z": float(center_z),
        "size_x": float(size_x),
        "size_y": float(size_y),
        "size_z": float(size_z)
    }
    with open(output_grid, 'w') as f:
        json.dump(grid_info, f, indent=4)
    print('Center: ({:.6f}, {:.6f}, {:.6f})'.format(center_x, center_y, center_z))
    print('Size: ({:.6f}, {:.6f}, {:.6f})'.format(size_x, size_y, size_z))



def main():
    parser = argparse.ArgumentParser(description="Calculate the docking grid for the ligand")
    parser.add_argument('--ligand', required=True, help="Ligand path (.sdf)")
    parser.add_argument('--grid', required=True, help="Grid path (.json)")
    args = parser.parse_args()

    ligand_file = args.ligand
    grid = args.grid

    if not os.path.exists(grid):
        calculated_docking_grid_sdf(ligand_file, grid)
    else:
        print("Grid ya existe en", grid)

if __name__ == "__main__":
    main()

