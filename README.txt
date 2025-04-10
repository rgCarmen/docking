
                        :~!!~.                      
                      :Y5JJJY57.                    
                     .Y5!!!!!!P!                    
                    :^YP!!!!!7PJ:                   
                 :~!~..?P5YY55~:~!~.                
              :~!~:  !??7777?J?~  :~!~.             
    .~?JJ?7^~!~:   :Y?.       :JJ.   :!!^^7JJJJ!.   
   :Y5?777JG7    :7Y^           !Y7:   .?G5YYYYPP:  
   !B!!!!!!JP77?JJ~   ^^.   .^:  .!JJ?77PPJJJJJJB7  
   :Y5?777JGY77~.    ?&@Y   G@&!    :!77Y#5YYYYP5:  
    .~?JJY7!JY7.     :77:   ^?!.     .?YJ!7YYJ?~.   
         7:  ^J?.       ^Y5J:       .JJ:  ^7        
         :?    7Y.     .B&&@P      ^5!   .J.        
          !!    ?J      5@&&J     .P!    ?^         
           J:   ~P      .J57      :G:   ^?          
           :?   JY                 57   ?:          
            !J~?P.                 ^P!~!!           
          .75P55?.    .........    ^5P5PY~.         
          ~BYJJJJJ?Y77?JJJJJJJ?77?P5JJJJ5G^         
          ^G5YJJYYGJ.   .....    :PPYYYYP5:         
           :?Y555J~               .7JYYJ7.          
             ....                    ..      

______             ______           _                
| ___ \            | ___ \         | |               
| |_/ /__  ___  ___| |_/ /_   _ ___| |_ ___ _ __ ___ 
|  __/ _ \/ __|/ _ \ ___ \ | | / __| __/ _ \ '__/ __|
| | | (_) \__ \  __/ |_/ / |_| \__ \ ||  __/ |  \__ \
\_|  \___/|___/\___\____/ \__,_|___/\__\___|_|  |___/
                                                     
2023-08-24

The protein-ligand complexes of the Astex Diverse set and the 
PoseBusters Benchmark set as described in the paper 
"PoseBusters: AI-based docking methods fail to generate 
physically valid poses or generalise to novel sequences" [1]
with associated code at https://github.com/maabuu/posebusters

All protein-ligand complexes were originally submitted to the 
Protein Data Bank (PDB) [2]. The Astex Diverse set was curated 
by Hartshorn et al. [3] and contains 85 cases. The PoseBusters 
Benchmark set was curated by us using the PDB and contains 428 
cases. All complexes were downloaded from the PDB as MMTF [4] 
files and processed with PyMOL [5]. 

For each protein-ligand complex, there is one folder named after 
the PDB identifier and the CCD identifier indicating the ligand 
of interest. 

In each folder there are four files: 
1. PDB file PDB_CCD_protein.pdb: The protein structure without
   the ligand of interest without solvents and with all 
   cofactors. 
2. SDF file PDB_CCD_ligands.sdf: All instances of the ligand 
   of interest. 
3. SDF file PDB_CCD_ligand.sdf: One of the instances of the
   ligand of interest. This crystal pose marks the binding site 
   for those docking methods that require a binding site.
4. SDF file PDB_CCD_ligand_start_conf.sdf: One generated 
   molecule conformation for the ligand of interest generated 
   with RDKit's [6] ETKDGv3 [7] followed by an energy minimization 
   with the UFF [8]. 

For further details refer to the PoseBusters preprint [1].

The folder structure is:

  posebusters_paper_data/
  ├── astex_diverse_set_ids.txt
  ├── astex_diverse_set/
  │   ├── 2BSM_BSM/
  │   │   ├── 2BSM_BSM_ligand_start_conf.sdf
  │   │   ├── 2BSM_BSM_ligand.sdf
  │   │   ├── 2BSM_BSM_ligands.sdf
  │   │   └── 2BSM_BSM_protein.pdb
  │   └── ...
  ├── posebusters_benchmark_set_ids.txt
  ├── posebusters_benchmark_set/
  │   ├── 5S8I_2LY/
  │   │   ├── 5S8I_2LY_ligand_start_conf.sdf
  │   │   ├── 5S8I_2LY_ligand.sdf
  │   │   ├── 5S8I_2LY_ligands.sdf
  │   │   └── 5S8I_2LY_protein.pdb
  │   └── ...
  └── README.txt


References:

[1] Buttenschoen M, Morris GM, Deane CM. PoseBusters: AI-based docking methods fail to generate physically valid poses or generalise to novel sequences. arXiv; 2023. Available from: http://arxiv.org/abs/2308.05777

[2] H.M. Berman, J. Westbrook, Z. Feng, G. Gilliland, T.N. Bhat, H. Weissig, I.N. Shindyalov, P.E. Bourne, The Protein Data Bank (2000) Nucleic Acids Research 28: 235-242 https://doi.org/10.1093/nar/28.1.235.

[3] Hartshorn MJ, Verdonk ML, Chessari G, Brewerton SC, Mooij WTM, Mortenson PN, et al. Diverse, high-quality test set for the validation of protein-ligand docking performance. J Med Chem. 2007 Feb 1;50(4):726–41. 

[4] Bradley AR, Rose AS, Pavelka A, Valasatava Y, Duarte JM, Prlić A, et al. MMTF—an efficient file format for the transmission, visualization, and analysis of macromolecular structures. Schneidman D, editor. PLoS Comput Biol. 2017 Jun 2;13(6):e1005575. 

[5] Schrödinger, LLC. The PyMOL molecular graphics system. 2015. Available from: https://github.com/schrodinger/pymol-open-source

[6] Landrum G, Tosco P, Kelley B, Ric, Sriniker, Gedeck, et al. RDKit Q3 2022 Release. Zenodo; 2023. Available from: https://zenodo.org/record/7671152

[7] Riniker S, Landrum GA. Better informed distance geometry: using what we know to improve conformation generation. J Chem Inf Model. 2015 Dec 28;55(12):2562–74. 

[8] Rappe AK, Casewit CJ, Colwell KS, Goddard WA, Skiff WM. UFF, a full periodic table force field for molecular mechanics and molecular dynamics simulations. J Am Chem Soc. 1992 Dec;114(25):10024–35. 


