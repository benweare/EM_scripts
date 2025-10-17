#!/usr/bin/bash -v

#declare functions
#activate conda and source dials
setup_conda()
{
    conda activate dials1
    conda activate /home/pczbw2/Documents/Dials
}
#go to working directory
gotodir()
{
    cd $work_dir
}
#pause script
pause_script()
{
    read -p "Press any key to continue"
}
#basic run, requires import.phil, find_spots.phil and pixels.mask to work
basic_run()
{
    #import data
    dials.import $image_path$image_file import.phil
    dials.apply_mask imported.expt input.mask=pixels.mask
    #find_spots
    dials.find_spots masked.expt min_spot_size=1 d_min=0.6 d_max=10 find_spots.phil
    #find rotation axis
    dials.find_rotation_axis masked.expt strong.refl
    #find_spots
    dials.find_spots optimised.expt min_spot_size=1 d_min=0.6 d_max=10 find_spots.phil
    #index
    dials.index optimised.expt strong.refl detector.fix=all beam.fix=all
    #refine bravais setting
    dials.refine_bravais_settings indexed.{expt,refl}
}
iterative_refine()
{
    dials.refine $input_name.{expt,refl} beam.fix=all detector.fix=all
    dials.refine refined.{expt,refl} detector.fix=all
    dials.refine refined.{expt,refl} beam.fix=all detector.fix=distance
    dials.reciprocal_lattice_viewer refined.{refl,expt} $latt_ops
}
integrate_data()
{
    dials.integrate refined.{expt,refl} d_min=0.6 d_max=10 background.algorithm=simple
    dials.two_theta_refine integrated.{expt,refl} cif=refined_cell.cif
    dials.symmetry refined._cell.expt integrated.refl
}
scale_data()
{
    scaling_options="d_min=0.8 absorption_level=high merging.nbins=10 error_model.grouping=individual"
    dials.two_theta_refine symmetrized.{expt,refl}
    dials.scale refined_cell.expt symmetrized.refl $scaling_options
    #dials.scale integrated.{expt,refl} d_min=0.8 absorption_level=high merging.nbins=10
}
report_results()
{
    dials.two_theta_refine $input_name.expt cif=refined_cell.cif
    dials.report $input_name.{expt,refl}
    python print_abscorr.py $input_name.expt
}
merge_experiments()
{
    dials.combine_experiments #experiments and images
}
show_reciprocal_lattice()
{
    dials.reciprocal_lattice_viewer $input_name.{refl,expt} $latt_ops
}
export_data()
{
    dials.export scaled.{expt,refl} format=shelx shelx.hklout=$s_name.hkl shelx.ins=$s_name.ins shelx.composition=$comp
}
image_viewer()
{
    dials.image_viewer $input_name.expt $refl_name.refl $img_view_ops
}
#declare variables
#specify image data path
image_path="/home/pczbw2/Documents/CMDdials/Paracetamol/Images/"
image_file="Paracetamol_230824_07.dm4"
work_dir="/home/pczbw2/Documents/CMDdials/Paracetamol/test"

input_name="refined"
refl_name="refined"

s_name="ZrBDC"
comp="Zr3C18O16"

#lattice viewer options
latt_ops="show_rotation_axis=True show_beam_vector=True show_reciprocal_cell=true"
img_view_ops="show_resolution_rings=True show_mask=True show_rotation_axis=True"
#script starts here
#echo "DIALS lattice refinement"

#basic_run
#iterative_refine
#integrated_data
export_data
#report_results
#show_reciprocal_lattice
#image_viewer

echo "end of script"
#end of script
#chmod +x ./source_dials.sh #permission to make file executable
# bash ./ # to run
