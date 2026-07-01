'''
 Class to communicate with an Oxford Instruments ICT503 temperature controller.

 Communicates over RS232 or GPIB interface, using PySerial. See ICT503 user
 manual for full explanation of the API and operational details.

 Author: E Weare
 Contact: benjamin.weare1@nottingham.ac.uk
 Location: nmRC
'''

import serial as serial
from time import sleep

class AccessError(Exception):
	'''
	Exception raised when accessing functions that may damage the controller if
	not used correctly.
	'''

	def __init__(self, message):
		self.message = message
		super().__init__(self.message)
		return

class SerialComms:
	'''
	Class for serial communications.
	'''
	def __init__( self ):
		self.serial_port = None
		return

	def open_port( self, pname='COM3', brate=9600, tout=2, wtout=2 ):
		'''
		Open the COM port (wrapper around serial.Serial).
		'''
		self.serial_port = serial.Serial(\
		port=pname,\
		baudrate=brate,\
		timeout=tout,\
		write_timeout=wtout,\
		bytesize=serial.EIGHTBITS,\
		parity=serial.PARITY_NONE )
		print('Opened port: ' + self.serial_port.name + '\n') #confirm which port is used
		return

	def write_port( self, command ):
		'''
		Write to the port.
		'''
		self.serial_port.reset_input_buffer()
		self.serial_port.reset_output_buffer()
		command = bytes(command.encode('utf-8'))
		self.serial_port.write( command )
		print('Sent: '+str(command))
		return

	def read_port( self ):
		'''
		Read the port and print the answer.
		'''
		message = self.serial_port.readline()
		print( 'Reply: ' + str(message.decode('utf-8')) )
		return

	def get_readout( self ):
		'''
		Read the port and return answer as a string.
		'''
		readout = self.serial_port.readline()
		readout = str(message.decode('utf-8'))
		return readout

	def test_ports( self ):
		'''
		Print the first availble COM port.
		'''
		from serial.tools import list_ports
		ports = list_ports.comports()
		print( ports[0] )
		return

	def close_port( self ):
		'''
		Close the COM port.
		'''
		self.serial_port.close( )
		print('Port closed.')
		return


# Function to write the commands into the correct syntax.
def _write_command( input, noreply=True ):
	if noreply == True:
		output = '$' + input + '\r'
	if noreply == False:
		output = input + '\r'
	return output


class Monitor:
	'''
	Class to contain serial communication commands.

	These commands are always recognised.

	API
	---
	Cn     : SET CONTROL LOCAL/REMOTE/LOCK 
	Qn     : DEFINE COMMUNICATION PROTOCOL
	Rn     : READ PARAMETER n 
	Unnnnn : UNLOCK FOR "!" AND SYSTEM COMMANDS 
	V READ : VERSION 
	Wnnnn  : SET WAIT INTERVAL BETWEEN OUTPUT CHARACTERS 
	X      : EXAMINE STATUS

	'''
	def __init__( self ):
		return

	def set_control( self, mode, locked ):
		'''
		Set control mode.
		'''
		mode = mode.lower()
		if mode == 'local' and locked == True:
			command = 'C0'
		if mode == 'remote' and locked == True:
			command = 'C1'
		if mode == 'local' and locked == False:
			command = 'C2'
		if mode == 'remote' and locked == False:
			command = 'C3'
		output = _write_command( command )
		return output

	def set_comm_protocol( self, mode ):
		'''
		'''
		mode = mode.lower()
		if mode == 'normal':
			output = 'Q0'
		else:
			output = 'Q1'
		output = _write_command( output )
		return output

	def read_variable( self, mode='0' ):
		'''
		Read a variable from 0 to 13.

		Notes
		-----
		0     : Set temperature
		1-3   : Sensor temperature
		4     : Temperature error
		5-6   : Heater OP (%, volts)
		7     : Gas flow OP
		8-10  : P, I, D
		11-13 : Channels 1,2, and 3 Freq/4
		'''
		output = 'R' + mode
		output = _write_command( output, False )
		return output

	def set_unlock( self, mode, **kwargs ):
		'''
		Warning:
		-------- 
		These may erase memory values. Do not use unless you
		are confident. See ICT503 manual for details.
		'''
		are_you_sure = kwargs.get('are_you_sure', False)
		mode = mode.lower()
		if are_you_sure == False:
			# Safety measure.
			error = AccessError('Using this function may erase controller\
				memory,see ICTO503 manual for details. Pass are_you_sure=True\
				to enable use of these commands.')
			print(error)
			return
		if mode == 'default':
			output = 'U0'
		if mode == '!':
			output = 'U1'
		if mode == 'sleep':
			output = 'U1234'
		if mode == 'wake':
			output = 'U4321'
		if mode == 'danger':
			output = 'U9999'
		else:
			# Safety measure.
			output = 'U0'
		output = _write_command( output )
		return output

	def read_version( self ):
		'''
		'''
		output = _write_command('V', False)
		return output

	def set_wait( self, delay='1000' ):
		'''
		Delay in miliseconds, formatted as 'nnnn'
		'''
		output = 'W'+ delay
		output = _write_command( output )
		return output

	#def examine( self ):
	#	return _write_command( 'X' )


class Control:
	'''
	Class to contain serial communication commands.

	API
	---
	An     : SET AUTO/MAN FOR HEATER & GAS 
	Dnnnn  : SET DERIVATIVE ACTION TIME 
	Fn     : SET FRONT PANEL TO DISPLAY PARAMETER n 
	Gnnn   : SET GAS FLOW (in MANUAL only) 
	Hn     : SET SENSOR FOR HEATER CONTROL 
	Innnn  : SET INTEGRAL ACTION TIME 
	Ln     : SET AUTO-PID (Learned PID's) 
	Mnnn   : SET MAXIMUM HEATER VOLTS LIMIT 
	Onnn   : SET OUTPUT VOLTS (in MANUAL only) 
	nnnn   : SET PROPORTIONAL BAND 
	Sn     : START/STOP SWEEP 
	Tnnnnn : SET DESIRED TEMPERATURE
	'''
	def __init__( self ):
		return

	def set_control( self, heater, gas ):
		'''
		Set control of heater and gas to manual or auto.
		'''
		heater = heater.lower()
		gas = gas.lower()
		if heater == 'manual' and gas == 'manual':
			output = 'A0'
		if heater == 'auto' and gas == 'auto':
			output = 'A1'
		if heater == 'manual' and gas == 'manual':
			output = 'A2'
		if heater == 'auto' and gas == 'auto':
			output = 'A3'
		output = _write_command( output )
		return output

	def set_P( self, input ):
		'''
		Set controller Proportional.
		'''
		output = 'P'+input
		output = _write_command( output )
		return output

	def set_I( self, input  ):
		'''
		Set controller Integral.
		'''
		output = 'I'+input
		output = _write_command( output )
		return output

	def set_D( self, input  ):
		'''
		Set controller Derviative.
		'''
		output = 'D'+input
		output = _write_command( output )
		return output

	def set_front_panel( self, input ):
		'''
		Set front panel to output a parameter other than temperature.

		Same syntax as 'R' command, Monitor.read_variable.
		'''
		output = 'F' + input
		output = _write_command( output )
		return output

	def set_gas_flow( self, input ):
		'''
		Set gas flow rate.
		'''
		output = 'G' + input
		output = _write_command( output )
		return output

	def set_heater_sensor(self, input='1'):
		'''
		Select sensor 1, 2, or 3.
		'''
		output = 'H' + input
		output = _write_command( output )
		return output

	def set_auto_PID( self, input ):
		'''
		Set whether to use the auto PID tables.
		'''
		if input == True:
			output = 'L0'
		if input == False:
			output = 'L1'
		else:
			output = 'L0'
		output = _write_command( output )
		return output

	def set_maximum_heater_voltage( self, input='1.0' ):
		'''
		Input in 0.1 V resolution.
		'''
		output = 'M' + input
		return

	def set_manual_heater_output(  self, input='0.0' ):
		'''
		Set as a percentage of maximum heater voltage in 0.1% steps.
		'''
		output = 'M' + input
		output = _write_command( output )
		return output

	def start_stop_sweep( self, input ):
		'''
		True to start, False to stop.
		'''
		if input == True:
			output = 'S1'
		else:
			output = 'S0'
		output = _write_command( output )
		return output

	def start_sweep_partway( self, input='1' ):
		'''
		Start a sweep at step n, where n in the range 2-32.
		'''
		output = 'S' + input
		output = _write_command( output )
		return output

	def set_temperature( self, input='20.00' ):
		'''
		Set target temperature.
		'''
		output = 'T' + input
		output = _write_command( output )
		return output


class System:
	'''
	Class to contain serial communication commands.

	Do not use these unless you are confident as they may
	wipe the on-board RAM.

	API
	---
	Y : LOAD ENTIRE RAM CONTENTS 
	Z : DUMP ENTIRE RAM CONTENTS
	~ : STORE RAM CONTENT TO EEPROM
	! : SET ISOBUS ADDRESS
	'''

	def __init__( self):
		return

	def _load_RAM( self, kilobytes=8 ):
		output = 'Y'+str(kilobytes)
		output = _write_command( output )
		return output

	def _dump_RAM( self, kilobytes=8 ):
		output = 'Z'+str(kilobytes)
		output = _write_command( output )
		return output

	def _store_RAM_to_EEPROM( self ):
		return _write_command( '~' )

	#def _set_isobus_address():
	#	# section 10.5 of manual
	#	return


class Specialist:
	'''
	Class to contain serial communication commands.

	These commands intended for engineer use. 

	API
	---
	xnnn   : SET TABLE POINTER x to nnn
	ynnn   : SET TABLE POINTER y to nnn 
	snnnnn : PROGRAM SWEEP TABLE 
	r READ : SWEEP TABLE 
	w WIPE : SWEEP TABLE
	pnnn   : PROGRAM AUTO PID TABLE PID
	q      : READ AUTO PID TABLE PID
	vnnn   : PROGRAM CUSTOM TARGET VOLTAGE TABLE
	t      : READ VALUE FROM TARGET VOLTAGE TABLE
	cnnn   : SET GAS FLOW CONFIGURATION PARAMETER
	d      : READ GAS FLOW CONFIGURATION PARAMETER
	m      : READ GAS FLOW CONTROL STATUS
	n      : READ TARGET VOLTS
	o      : READ VALVE SCALING
	'''

	def __init__( self ):
		return

	def _read_sweep_table( self ):
		return _write_command( 'r' )

	def _wipe_sweep_table( self ):
		return _write_command( 'w' )

	def _read_autopid_table( self ):
		return _write_command( 'q' )

	def _read_x_pointer(self):
		return _write_command( 't' )

	def _read_gas_flow_params(self):
		return _write_command( 'd' )

	def _read_flow_control(self):
		return _write_command( 'm' )

	def _read_target_voltage(self):
		return write_command( 'n' )

	def _read_valve_scaling(self):
		return write_command( 'o' )

	def _set_pointer( self, type, value ):
		'''
		type : string
			x, or y. 
		value : string
			0 to 128
		'''
		output = type + string
		output = write_command( output )
		return output

	#def set_sweep_table(self):
	#	return

	#def set_autopid_table(self):
	#	return

	#def set_heater_voltage_table(self):
	#	return


class ICT503( Monitor, Control ):
	'''
	Child class for ICT503.
	'''
	def __init__( self ):
		print('Init ICT503.\n')
		return


# Some functions for common tasks.
def change_set_temperature( comdevice, comport, temp='20.00' ):
	'''
	Change the set temperature.
	'''
	comstring = comdevice.set_temperature( temp )
	comport.write_port( comstring )
	return

def read_temperature_variables( comdevice, comport ):
	'''
	Read the set and current temperature.
	'''
	comport.write_port( comdevice.read_variable('0') )
	comport.read_port()
	comport.write_port( comdevice.read_variable('1') )
	comport.read_port()
	return

def readout_continuous( comdevice, comport, readings=1000 ):
	'''
	Get temperature readings continuously.
	'''
	try:
		while x < readings:
			comport.write_port( comdevice.read_variable('0') )
			x + x + 1
			sleep( 1 )
	except KeyboardInterrupt:
		print('User interrupt.')
	return


# Main script here.
comdevice = ICT503()
COM3 = SerialComms()

# Open COM port.
COM3.open_port()
# Set to remote operation.
COM3.write_port(comdevice.set_control('remote', False))
# Change the set temperature.
change_set_temperature( comdevice, COM3, '20.00' )
# Read back the current and set temperature.
read_temperature_variables( comdevice, COM3 )
# Set to local control.
COM3.write_port(comdevice.set_control('local', False))
# Close COM port.
COM3.close_port()
# End of script.