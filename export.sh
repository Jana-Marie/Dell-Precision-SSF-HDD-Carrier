#!/bin/bash
 
OUTDIR='./out'
declare -a StringArray=("stack" "case_holder" "case_to_plate" "interlock_mech" "interlock_base" "interlock_to_plate" )

mkdir $OUTDIR

for val in ${StringArray[@]}; do
   openscad -DPART=$val -o $OUTDIR/$val.stl $1
done

