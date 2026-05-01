#!/usr/bin/bash -v

# Some functions for running DIALS via Linux terminal.
# See: https://dials.github.io/
# Make file executeable: chmod +x ./source_dials.sh
# Run file: bash ./ # to run

# Source DIALS env.
setup_conda()
{
    #conda activate dials1
    conda activate /home/pczbw2/Documents/Dials
}
# Go to working directory.
gotodir()
{
    cd $work_dir
}
# Pause script.
pause_script()
{
    read -p "Press any key to continue"
}
# Basic run. Requires import.phil, find_spots.phil and pixels.mask to work.
basic_run()
{
    # Import data.
    dials.import $image_path$image_file import.phil
    dials.apply_mask imported.expt input.mask=pixels.mask
    # Find spots.
    dials.find_spots masked.expt min_spot_size=1 d_min=0.6 d_max=10 find_spots.phil
    # Find rotation axis.
    dials.find_rotation_axis masked.expt strong.refl
    # Find spots.
    dials.find_spots optimised.expt min_spot_size=1 d_min=0.6 d_max=10 find_spots.phil
    # Index spots.
    dials.index optimised.expt strong.refl detector.fix=all beam.fix=all
    # Refine bravais setting.
    dials.refine_bravais_settings indexed.{expt,refl}
}
# Refine the experiment for microED.
iterative_refine()
{
    dials.refine $input_name.{expt,refl} beam.fix=all detector.fix=all
    dials.refine refined.{expt,refl} detector.fix=all
    dials.refine refined.{expt,refl} beam.fix=all detector.fix=distance
    dials.reciprocal_lattice_viewer refined.{refl,expt} $latt_ops
}
# Integrate the experiment.
integrate_data()
{
    dials.integrate refined.{expt,refl} d_min=0.6 d_max=10 background.algorithm=simple
    dials.two_theta_refine integrated.{expt,refl} cif=refined_cell.cif
    dials.symmetry refined._cell.expt integrated.refl
}
# Scale the integrated data.
scale_data()
{
    scaling_options="d_min=0.8 absorption_level=high merging.nbins=10 error_model.grouping=individual"
    dials.two_theta_refine symmetrized.{expt,refl}
    dials.scale refined_cell.expt symmetrized.refl $scaling_options
    #dials.scale integrated.{expt,refl} d_min=0.8 absorption_level=high merging.nbins=10
}
# Create reports of data reduciton process.
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
# Variables:
# Image data path.
image_path="/home/pczbw2/Documents/CMDdials/Paracetamol/Images/"
image_file="Paracetamol_230824_07.dm4"
work_dir="/home/pczbw2/Documents/CMDdials/Paracetamol/test"

input_name="refined"
refl_name="refined"

s_name="ZrBDC"
comp="Zr3C18O16"

# Lattice viewer options.
latt_ops="show_rotation_axis=True show_beam_vector=True show_reciprocal_cell=true"
img_view_ops="show_resolution_rings=True show_mask=True show_rotation_axis=True"

# Script starts here.
# echo "DIALS lattice refinement"

basic_run
iterative_refine
integrate_data
export_data
report_results
show_reciprocal_lattice
image_viewer

echo "end of script"
# End of script.