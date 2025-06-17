from rdkit import Chem
import argparse
import deepdock
from deepdock.prepare_target.computeTargetMesh import compute_inp_surface
from deepdock.models import *
from deepdock.DockingFunction import dock_compound, get_random_conformation

import numpy as np
import torch
import subprocess
# set the random seeds for reproducibility
#obabel input.sdf -O output.mol2 -h (hidrógenos implícitos)

parser = argparse.ArgumentParser(description="DeepDock docking automation script.")
parser.add_argument("basename", type=str, help="Basename of the protein/ligand (e.g., {basename})")
args = parser.parse_args()

basename = args.basename
protein_filename =f"{basename}_protein.pdb"
ligand_filename = f"{basename}_ligand.mol2"

copy_pdb = ['cp', f'../posebusters_benchmark_set/{basename}/{protein_filename}', '.']
copy_mol2 = ['cp', f'../posebusters_benchmark_set/{basename}/{ligand_filename}', '.']
subprocess.run(copy_pdb)
subprocess.run(copy_mol2)

np.random.seed(123)
torch.cuda.manual_seed_all(123)

# Crear mesh (pymesh) .ply
compute_inp_surface(protein_filename, ligand_filename, dist_threshold=10)

# Cargar modelo
device = 'cuda' if torch.cuda.is_available() else 'cpu'

ligand_model = LigandNet(28, residual_layers=10, dropout_rate=0.10)
target_model = TargetNet(4, residual_layers=10, dropout_rate=0.10)
model = DeepDock(ligand_model, target_model, hidden_dim=64, n_gaussians=10, dropout_rate=0.10, dist_threhold=7.).to(device)

checkpoint = torch.load(deepdock.__path__[0]+'/../Trained_models/DeepDock_pdbbindv2019_13K_minTestLoss.chk', map_location=torch.device(device))
model.load_state_dict(checkpoint['model_state_dict']) 



# Dock

real_mol = Chem.MolFromMol2File(ligand_filename,sanitize=False, cleanupSubstructures=False)

opt_mol, init_mol, result = dock_compound(real_mol, f"{basename}_protein.ply", model, dist_threshold=3., popsize=150, seed=123, device=device)


print("Molecule")
print(opt_mol)

sdf_result = Chem.MolToMolBlock(opt_mol, kekulize=False)  
with open(f"../posebusters_benchmark_set/{basename}/{basename}_ligand_opt_deepdock.sdf", "w") as f:  
    f.write(sdf_result)