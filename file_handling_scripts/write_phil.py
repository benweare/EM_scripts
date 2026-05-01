# write a .phil for DIALS import of 3DED data
class data():
    image_size = '512 512' # in pixels
    camera_length = '80.41' #in mm
    beam_center = '270 260' # in pixels
    tilt_start = '-40.01' # in degrees
    tilt_step = '0.117326' # in degrees
    wavelength = '0.0251' # in Angstroms
    camera = 'Gatan K3' #'Gatan OneView'
    axis_angle = '-0.656059 0.75471 0'
    pixel_size = '0.005 0.005' #'0.015 0.015'

    string = ''\
    'geometry {\n'\
    '  beam {\n'\
    '    probe = x-ray *electron neutron\n'\
    '    wavelength = ' + wavelength + '\n'\
    '  }\n'\
    '  detector {\n'\
    '    panel {\n'\
    '      name = ' + camera + '\n'\
    '    }\n'\
    '    panel {\n'\
    '      material = "Si"\n'\
    '    }\n'\
    '    panel {\n'\
    '      pixel_size = ' + pixel_size + '\n'\
    '    }\n'\
    '    panel {\n'\
    '      image_size = ' + image_size + '\n'\
    '    }\n'\
    '    panel {\n'\
    '      trusted_range = -1000000 4294967295\n'\
    '    }\n'\
    '    panel {\n'\
    '      gain = 1\n'\
    '    }\n'\
    '    distance = ' + camera_length + '\n'\
    '    fast_slow_beam_centre = ' + beam_center + '\n'\
    '  }\n'\
    '  goniometer {\n'\
    '    axes = ' + axis_angle + '\n'\
    '  }\n'\
    '  scan {\n'\
    '    oscillation =  ' + tilt_start + ' ' + tilt_step + '\n'\
    '  }\n'\
    '}\n'

print( data.string )
