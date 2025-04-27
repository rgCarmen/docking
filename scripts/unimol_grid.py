import json
import numpy as np
import pandas as pd
from tqdm import tqdm
from rdkit import Chem
import os
from typing import Optional
from rdkit import Chem
import argparse


#Calculate grid
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
    parser = argparse.ArgumentParser(description="Compute the docking grid for the ligand")
    parser.add_argument('--ligand', required=True, help="Ligand path (.sdf)")
    parser.add_argument('--grid', required=True, help="Grid path (.json)")
    args = parser.parse_args()

    ligand_file = os.path.expanduser(args.ligand)
    grid = os.path.expanduser(args.grid)

    if not os.path.exists(grid):
        calculated_docking_grid_sdf(ligand_file, grid)
    else:
        print("Grid ya existe en", grid)

if __name__ == "__main__":
    main()

"""

#Generate the input metainfo csv file required for the interface

df = pd.DataFrame(columns=['input_protein', 'input_ligand', 'input_docking_grid', 'output_ligand_name'])
input_meta_info_file = 'posebuster_428_one2one.csv'
predict_name_suffix = 'predict'
for i, item in tqdm(enumerate(zip(pdb_ids,lig_ids))):
    pdbid, ligid = item
    single_protein_path = os.path.abspath(os.path.join(protein_path, pdbid + '.pdb'))
    single_ligand_path = os.path.abspath(os.path.join(ligand_path, f'{pdbid}_{ligid}.sdf'))
    single_grid_path = os.path.abspath(os.path.join(grid_path, pdbid + '.json'))
    predict_name = f'{pdbid}_{predict_name_suffix}'
    df.loc[i] = [single_protein_path, single_ligand_path, single_grid_path, predict_name]
print(df.info())
print(df.head(3))
df.to_csv(input_meta_info_file, index= False)


#Inference: use the model trained on moad
predict_sdf_dir = f'predict_sdf_posebuster428_grid{add_size}'

!python demo.py --mode batch_one2one --batch-size 8 --steric-clash-fix --conf-size 10 --cluster \
        --input-batch-file $input_meta_info_file \
        --output-ligand-dir $predict_sdf_dir \
        --model-dir checkpoint_best.pt
"""


"""
python demo.py --mode single --conf-size 10 --cluster \
        --input-protein ~/docking/data_sets/astex_diverse_set/1G9V_RQ3/1G9V_RQ3_protein.pdb \
        --input-ligand ~/docking/data_sets/astex_diverse_set/1G9V_RQ3/1G9V_RQ3_ligand.sdf \
        --input-docking-grid ~/docking/data_sets/astex_diverse_set/1G9V_RQ3/1G9V_RQ3.json \
        --output-ligand-name 1G9V_RQ3_unimol \
        --output-ligand-dir ~/docking/data_sets/astex_diverse_set/1G9V_RQ3 \
        --steric-clash-fix \
        --model-dir ~/unimol_docking_v2_240517.pt
"""