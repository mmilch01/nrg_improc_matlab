#!/bin/bash
T=/nrgpackages/tools/HCP/scripts/matlab

surf_files="mask_surf.m projectVol.m RectangularMesh.m maskVol.m blur3_thin.m fill_layer.m"
routines_files="mask_surf_auto.m dispvol3D.m dispvol.m blur3.m saveVol.m"

pushd surf
cp -rf $surf_files $T/surf
popd

pushd routines
cp -rf $routines_files $T/routines
popd

pushd $T 

