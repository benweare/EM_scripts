'''
Some Python to model the lenses in a JEOL2100Plus TEM.

The y-axis should be relatively close to scale, based off
of the diagrams in the manual. The x-axis is not to scale.

Uses EMRayTracing fork of TEMGymBasic, but should work
fine with 0.0.6 verison of TEMGymBasic.
'''

import EMRayTracing
from EMRayTracing import components as comp
from EMRayTracing.model import Model
from EMRayTracing.run import show_matplotlib

import matplotlib
import matplotlib.pyplot as plt

import numpy as np


def show_rays_only(model, name = 'model.svg', component_lw = 4,
    edge_lw = 1, label_fontsize = 20, **kwargs):
    '''
    Custom matplotlin diagram based off of TEMGymBasic.
    '''

    # kwargs
    fig = kwargs.get('figure', None)
    ax = kwargs.get('axis', None)
    is_labels = kwargs.get('labels', True)
    figsize = kwargs.get('figsize',  [12, 20])
    plot_rays = kwargs.get('plot_rays', True)
    label_x = kwargs.get('label_x', 0.1)
    rcol = kwargs.get('rcol', 'dimgray')
    fcol = kwargs.get('rcol', 'aquamarine')
    fcolpair = kwargs.get('rcol', ['khaki', 'deepskyblue'])

    highlight_edges = kwargs.get('highlight_edges', False)
    fill_between = kwargs.get('fill_between',True )
    

    #Step the rays through the model to get the ray positions throughout the column
    rays = model.step()
    #Collect their x, y & z coordinates
    x, y, z = rays[:, 0, :], rays[:, 2, :], model.z_positions


    #Create a figure
    if (fig == None and ax == None):
        fig, ax = plt.subplots(figsize=(figsize[0], figsize[1]))
    elif (fig == None and ax != None):
        fig, _ = plt.subplots(figsize=(figsize[0], figsize[1]))
    elif (fig != None and ax == None):
        _, ax = plt.subplots(figsize=(figsize[0], figsize[1]))

    ax.tick_params(axis='both', which='major', labelsize=14)
    ax.tick_params(axis='both', which='minor', labelsize=12)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['bottom'].set_visible(False)
    #ax.spines['left'].set_visible(False)
    #ax.grid(color='lightgrey', linestyle='--', linewidth=0.5)
    #ax.grid(which='minor', color='#EEEEEE', linestyle=':', linewidth=0.5)

    #ax.set_yticks([])
    #ax.set_yticklabels([])
    ax.set_xticklabels([])
    ax.set_ylabel('Distance / m')
    
    ax.get_xaxis().set_ticks(
        [-model.detector_size/2, 0, model.detector_size/2])
    ax.set_xlim([-0.5, 0.5])
    ax.set_ylim([0, model.beam_z])
    ax.set_aspect('equal', adjustable='box')
    if is_labels == True:
      ax.text(label_x, model.beam_z, 'Electron Gun', fontsize=label_fontsize, zorder = 1000)
    
    #Set starting index of component so that we can plot rays from one component to the next
    idx = 1

    #Generate a list of the allowed rays, so we can block them when they hit an aperture
    allowed_rays = range(model.num_rays)
    
    #Set colors of rays
    ray_color = rcol
    fill_color = fcol
    fill_color_pair = fcolpair

    fill_alpha = 1
    ray_alpha = 1

    # Width of rays in diagram.
    ray_lw = 0.15

    edge_rays = [0, model.num_rays-1]
    
    #Loop through components, and for each type of component plot rays in the correct ray,
    #and increment the index correctly
    for component in model.components:
        if allowed_rays != []:
            if highlight_edges == True:
                ax.plot(x[idx-1:idx+1, edge_rays], z[idx-1:idx+1],
                        color='k', linewidth=edge_lw, alpha=1, zorder=2)
            if fill_between == True:
                pair_idx = 0
                for first, second in zip(edge_rays[::2], edge_rays[1::2]):
                    if len(edge_rays) == 4:
                        ax.fill_betweenx(z[idx-1:idx+1], x[idx-1:idx+1, first], x[idx-1:idx+1, second],
                                         color=fill_color_pair[pair_idx], edgecolor=fill_color_pair[pair_idx], alpha=fill_alpha, zorder=0, lw=None)
                        pair_idx += 1
                    else:
                        ax.fill_betweenx(z[idx-1:idx+1], x[idx-1:idx+1, first], x[idx-1:idx+1, second],
                                         color=fill_color, edgecolor=fill_color, alpha=fill_alpha, zorder=0, lw=None)
            if plot_rays == True:
                ax.plot(x[idx-1:idx+1, allowed_rays], z[idx-1:idx+1],
                        color=ray_color, linewidth=ray_lw, alpha=ray_alpha, zorder=1)

        if component.type == 'Aperture':
            if is_labels == True:
                ax.text(label_x, component.z-0.01,
                        component.name, fontsize=label_fontsize, zorder = 1000)
            ri = component.aperture_radius_inner
            ro = component.aperture_radius_outer/6
            ax.plot([-ri, -ro], [z[idx], z[idx]],
                    color='dimgrey', alpha=1, linewidth=component_lw, zorder=999)
            ax.plot([ri, ro], [z[idx], z[idx]],
                    color='dimgrey', alpha=1, linewidth=component_lw, zorder=999)
            ax.plot([-ri, -ro], [z[idx], z[idx]],
                    color='k', alpha=1, linewidth=component_lw+2, zorder=998)
            ax.plot([ri, ro], [z[idx], z[idx]],
                    color='k', alpha=1, linewidth=component_lw+2, zorder=998)
            idx += 1

        elif component.type == 'Lens':
            if is_labels == True:
                ax.text(label_x, component.z-0.01,
                        component.name, fontsize=label_fontsize, zorder = 1000)
            ax.add_patch(matplotlib.patches.Arc((0, component.z), component.radius/2, height=0.01,
                                         theta1=0, theta2=180, linewidth=1, fill=False, zorder=-1, edgecolor='k'))
            ax.add_patch(matplotlib.patches.Arc((0, component.z), component.radius/2, height=0.01,
                                         theta1=180, theta2=0, linewidth=1, fill=False, zorder=999, edgecolor='k'))
            idx += 1

        elif component.type == 'Sample':
            if is_labels == True:
                ax.text(label_x, component.z-0.01,
                        component.name, fontsize=label_fontsize, zorder = 1000)
            w = component.width
            ax.plot([component.x-w/4, component.x+w/4], [z[idx], z[idx]],
                    color='dimgrey', alpha=0.8, linewidth=3)
            
            idx += 1

        allowed_rays = list(set(allowed_rays).difference(
            set(component.blocked_ray_idcs)))
        allowed_rays.sort()

        if len(allowed_rays) > 0:
            edge_rays = [allowed_rays[0], allowed_rays[-1]]
            new_edges = np.where(np.diff(allowed_rays) != 1)[0].tolist()

            for new_edge in new_edges:
                edge_rays.extend(
                    [allowed_rays[new_edge], allowed_rays[new_edge+1]])

            edge_rays.sort()

        else:
            break
        
    #We need to repeat the code once more for the rays at the end
    if allowed_rays != []:
        if highlight_edges == True:
            ax.plot(x[idx-1:idx+1, edge_rays], z[idx-1:idx+1],
                    color='k', linewidth=edge_lw, alpha=1, zorder=2)
        if fill_between == True:
            pair_idx = 0
            for first, second in zip(edge_rays[::2], edge_rays[1::2]):
                if len(edge_rays) == 4:
                    ax.fill_betweenx(z[idx-1:idx+1], x[idx-1:idx+1, first], x[idx-1:idx+1, second],
                                     color=fill_color_pair[pair_idx], edgecolor=fill_color_pair[pair_idx], alpha=fill_alpha, zorder=1)
                    pair_idx += 1
                else:
                    ax.fill_betweenx(z[idx-1:idx+1], x[idx-1:idx+1, first], x[idx-1:idx+1, second],
                                     color=fill_color, edgecolor=fill_color, alpha=fill_alpha, zorder=0)
        if plot_rays == True:
            ax.plot(x[idx-1:idx+1, allowed_rays], z[idx-1:idx+1],
                    color=ray_color, linewidth=ray_lw, alpha=ray_alpha, zorder=1)
    
    #Create the final labels and plot the detector shape
    if is_labels == True:
        ax.text(label_x, -0.01, 'Detector', fontsize=label_fontsize, zorder = 1000)
    ax.plot([-model.detector_size/2, model.detector_size/2],
            [0, 0], color='dimgrey', alpha=1, linewidth=component_lw)
    
    return fig, ax

class lens_settings:
    '''
    Class to contain lens settins for different illumination and
    magnification modes.
    '''
    def __init__(self, alpha = 1, mag_range = 1, wavelength_factor=1):
        # Some standard settings.
        self.default = np.array([\
                    -0.05,# Gun, sets the gun spread
                    -0.015,# CL1
                    -0.010,# CL2
                    -0.015,# CL3
                    -0.1,# CM
                    -0.8,# OL1
                    -0.01,# OM
                    -0.05,# OL2
                    -0.015,# IL1
                    -0.015,# IL2
                    -0.02,# IL3
                    -0.012])# PL
        # Custom settings.
        self.gun_angle = [-0.05] # rad
        if alpha == 3:
            self.condenser = np.array([\
                    -0.015,# CL1
                    -0.010,# CL2
                    -0.008,# CL3
                    -0.1])# CM
        elif alpha == 2:
            self.condenser = np.array([\
                    -0.015,# CL1
                    -0.010,# CL2
                    -0.011,# CL3
                    -0.1])# CM
        elif alpha == 1:
            self.condenser = np.array([\
                    -0.015,# CL1
                    -0.010,# CL2
                    -0.015,# CL3
                    -0.1])# CM

        if mag_range == 0:
            # diff mode, not working
            self.imaging = np.array([\
                    -0.8,# OL1
                    -1.0,# OM
                    -0.03,# OL2
                    -0.01,# IL1
                    -0.015,# IL2
                    -0.02,# IL3
                    -0.015])# PL
        elif mag_range == 1:
            # 40 - 800 kX
            self.imaging = np.array([\
                    -0.8,# OL1
                    -1.0,# OM
                    -0.05,# OL2
                    -0.015,# IL1
                    -0.015,# IL2
                    -0.02,# IL3
                    -0.015])# PL

        self.settings = np.concatenate((self.gun_angle,\
                                        self.condenser,\
                                        self.imaging))

        self.wavelength_factor =  wavelength_factor
        self.settings = self.settings*self.wavelength_factor
        print(self.settings)
        return

def _calculate_height( rel_height, scale_factor ):
    # Absolute height.
    # Scale diagram. 
    # 1 = mm, 1:10 scale
    # 0.01 = m, 1:1 scale
    height = np.flip(np.cumsum( np.flip(rel_height), axis=-1 ))
    top = height[0]
    top = top * scale_factor
    height = height * scale_factor
    return height, top


# Relative height of components measured from bottom up, in mm.
# Taking viewing screen as the 0 height.
# Distance in mm. 1:10 scale
relative_heights = np.array( [\
            6,# Gun
            4,# CL1
            4,# CL2
            4,# CL3
            2,# CA
            4,# C STIG
            3,# C DEF
            11,# CM
            # x-ray aperture
            4,# Specimen
            3,# OA
            4,# OL STIG
            1,# OL1
            2,# OM
            1.5,# OL2
            5,# IMAGE SHIFT - 2 deflectors
            3,# SA
            0,# ILSTIG
            5.0,# IL1
            5.0,# IL2
            2.5,# IL3
            2.5,# PL DEF
            15,# PL - really 33 above viewing screene
            0\
            ])# Screen for reference


scale_factor = 0.01
height, top = _calculate_height( relative_heights, scale_factor )

lens_settings = lens_settings(alpha=3, mag_range=1, wavelength_factor=1.00)

# Focal length of lenses in m
focal_length = lens_settings.settings

# Aperture diameters.
cond_a = 0.01
obj_a = 0.01

# Components in microscope model.
# Taking the gun as the first crossover.
components = [\
              comp.Lens(name = 'CL1', 
                z = height[1], 
                f = focal_length[1]),
              comp.Lens(name = 'CL2', 
                z = height[2], 
                f = focal_length[2]),
              comp.Lens(name = 'CL3', 
                z = height[3], 
                f = focal_length[3]),
              comp.Aperture(name = 'CA', 
                z = height[4], 
                aperture_radius_inner = cond_a),
              comp.Lens(name = 'CM', 
                z = height[7], 
                f = focal_length[4]),
              comp.Sample(name = 'Sample',
                sample = np.zeros((5,2)),
                z = height[8]),
              comp.Aperture(name = 'Objective Aperture', 
                z = height[9], 
                aperture_radius_inner = obj_a),
              comp.Lens(name = 'OM', 
                z = height[12], 
                f = focal_length[6]),
              comp.Lens(name = 'OL', 
                z = height[13], 
                f = focal_length[7]),
              comp.Lens(name = 'IL1', 
                z = height[17], 
                f = focal_length[8]),
              comp.Lens(name = 'IL2', 
                z = height[18], 
                f = focal_length[9]),
              comp.Lens(name = 'IL3', 
                z = height[19], 
                f = focal_length[10]),
              comp.Lens(name = 'PL', 
                z =height[21], 
                f = focal_length[11])
              ]

screen_width = 18 *scale_factor


# Make the model.
plus_model = Model(components,
				beam_z=top,
				beam_type='x_axial',
                num_rays=32,
                gun_beam_semi_angle=focal_length[0],
                beam_tilt_x=0,
                detector_size=screen_width)
name = 'model_tem.svg'

# Make the mpl figure.
fig, ax = show_rays_only(plus_model,
                            name = name,
                            label_fontsize = 12,
                            labels = True,
                            plot_rays=True,
                            fill_between=False)
#fig.suptitle('2100Plus Scale Model',fontsize=10)

# Show the figure.
plt.show()