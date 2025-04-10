import py3Dmol
from rdkit import Chem
from rdkit.Chem import AllChem


protein_file= '/home/carmen/tfg/astex_diverse_set/1G9V_RQ3/1G9V_RQ3_protein.pdb'
ligand_og_file= "/home/carmen/tfg/astex_diverse_set/1G9V_RQ3/1G9V_RQ3_ligand.sdf"
ligand_dock_file= "/home/carmen/tfg/DiffDock/results_astex/1G9V_RQ3/complex_0/rank1.sdf"

out_representation= "visualizacion1G9V_RQ3.html"

with open(protein_file) as ifile:
    protein = ifile.read()

dock_mol = Chem.SDMolSupplier(ligand_dock_file)[0]     
init_mol = Chem.SDMolSupplier(ligand_og_file)[0] 


p = py3Dmol.view(width=500, height=500)

#Proteina
p.addModel(protein, 'pdb')

# Ligandos
p.addModel(Chem.MolToMolBlock(dock_mol), 'sdf')
p.addModel(Chem.MolToMolBlock(init_mol), 'sdf')

# Modelos
protein = {'model': 0}
lig_dock = {'model': 1}  
lig_init = {'model':2}  

# Estilos de representación
p.setStyle(protein, {'cartoon': {'color': 'gray'}})  
p.setStyle(lig_init, {'stick': {'color': 'blue'}}) 
p.setStyle(lig_dock, {'stick': {'color': 'red'}})  

# Leyenda
p.addLabel("Proteína", {'position': {'x': 30, 'y': 55, 'z': 0}, 'fontColor': 'gray', 'backgroundColor': 'white'})
p.addLabel("Ligando Predicha", {'position': {'x': 28, 'y': 50, 'z': 0}, 'fontColor': 'red', 'backgroundColor': 'white'})
p.addLabel("Ligando Inicial", {'position': {'x': 28, 'y': 45, 'z': 0}, 'fontColor': 'blue', 'backgroundColor': 'white'})

p.zoomTo()
#p.show()

with open(out_representation, "w") as f:
    f.write(p._make_html())