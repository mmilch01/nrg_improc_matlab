#!/bin/bash
T=~/bin/matlab/surfacemask

surf_files="mask_surf.m projectVol.m RectangularMesh.m maskVol.m blur3_thin.m fill_layer.m"
routines_files="mask_surf_auto.m dispvol3D.m dispvol.m blur3.m saveVol.m"

pushd surf
cp -rf $surf_files $T
popd

pushd routines
cp -rf avw*.m $T
cp -rf $routines_files $T
popd

pushd $T 

for f in $surf_files; do add_license $f; done
for f in $routines_files; do add_license $f; done
rm *.bk
