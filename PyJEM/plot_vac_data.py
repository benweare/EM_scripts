import numpy as np
import matplotlib.pyplot as plt

def _import_csv_to_np( datafile, **kwargs ):
    lim = kwargs.get('lim', [None, None])
    data = np.genfromtxt(datafile, delimiter=',', comments='#')
    x = data[lim[0]:lim[1],0]
    y = data[lim[0]:lim[1],1:]
    return x, y

# Give limit in seconds.
x, y = _import_csv_to_np( '2026-05-13_164434_pressure.csv', lim=[0, 210*60] )

fig, axs = plt.subplots(3, 1)

# All data
axs[0].plot(x/60, y[:,0], label='Peg1: Column', color='blue')
axs[0].plot(x/60, y[:,1], label='Pig1: Column', color='orange')
axs[0].plot(x/60, y[:,2], label='Pig2: Gun', color='green')
axs[0].plot(x/60, y[:,3], label='Pig3: Dectector', color='red')
axs[0].plot(x/60, y[:,4], label='Pig4: Specimen', color='purple')
axs[0].plot(x/60, y[:,5], label='Pig5: RT1', color='brown')
axs[0].plot(x/60, y[:,6], label='Pig6', color='pink')

axs[1].plot(x/60, y[:,1], label='Pig1: Column', color='orange')
axs[1].plot(x/60, y[:,2], label='Pig2: Gun', color='green')
axs[1].plot(x/60, y[:,3], label='Pig3: Dectector', color='red')
axs[1].plot(x/60, y[:,5], label='Pig5: RT1', color='brown')

axs[2].plot(x/60, y[:,1], label='Pig1: Column', color='orange')
axs[2].plot(x/60, y[:,2], label='Pig2: Gun', color='green')
axs[2].plot(x/60, y[:,3], label='Pig3: Dectector', color='red')

for ax in axs:
    ax.set_xlabel('Time / min')
    ax.set_ylabel('Pressure / s')
    ax.set_ylim([None, None])

labels = ['Peg1: Column', 'Pig1: Column', 'Pig2: Gun', 'Pig3: Dectector', 'Pig4: Specimen', 'Pig5: RT1', 'Pig6']
fig.legend(labels)

plt.show()