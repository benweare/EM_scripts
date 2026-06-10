'''

Script to communicate with an Oxford Instruments ICT503.

Communicates over RS232 or GPIB interface, using PySerial. 

'''

import serial as serial

class SerialComms:
	'''
	Class for serial communications.
	'''
	def __init__( self ):
		self.serial_port = None
		return

	def open_port( self, pname='COM3', brate=9600, tout=2, wtout=2 ):
		self.serial_port = serial.Serial(\
		port=pname,\
		baudrate=brate,\
		timeout=tout,\
		write_timeout=wtout,\
		bytesize=serial.EIGHTBITS,\
		parity=serial.PARITY_NONE )
		print('Serial port: ' + serial_port.name + '\n') #confirm which port is used
		return

	def write_port( self, command ):
		self.serial_port.reset_input_buffer()
		self.serial_port.reset_output_buffer()
		command.encode('utf-8')
		self.serial_port.write( command )
		return

		#ser.reset_input_buffer() #clear input queue
		#ser.reset_output_buffer() #clear output buffer
		#ser.close() #close port

	def test_ports( self ):
		from serial.tools import list_ports
		print(list_ports.comports())
		return

	def close_port( self ):
		self.serial_port.close( )
		return


# Function to write the commands into the correct syntax.
def _write_command( input, noreply=True ):
	if noreply == True:
		output = '$' + input + r'\r'
	if noreply == False:
		output = + input + r'\r'
	return output


class Monitor:
	'''
	Class to contain serial communication commands.

	These commands are always recognised.

	API
	---
	Cn   SET CONTROL LOCAL/REMOTE/LOCK 
	Qn   DEFINE COMMUNICATION PROTOCOL
	Rn   READ PARAMETER n 
	Unnnnn UNLOCK FOR "!" AND SYSTEM COMMANDS 
	V READ VERSION 
	Wnnnn SET WAIT INTERVAL BETWEEN OUTPUT CHARACTERS 
	X EXAMINE STATUS

	'''
	def __init__( self ):
		return

	def set_control( self, mode, locked ):
		mode = mode.lower()
		if mode == 'local' and locked == True:
			command = 'C0'
		if mode == 'remote' and locked == True:
			command = 'C1'
		if mode == 'local' and locked == False:
			output = 'C2'
		if mode == 'remote' and locked == False:
			command = 'C3'
		output = _write_command( command )
		return output

	def set_comm_protocol( self, mode ):
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
		0 Set temperature
		1-3 Sensor temperature
		4 Temperature error
		5-6 Heater OP (%, volts)
		7 Gas flow OP
		8-10 P, I, D
		11-13 Channels 1,2, and 3 Freq/4
		'''
		output = 'R' + mode
		output = _write_command( output )
		return output

	def set_unlock( self, mode ):
		'''
		Warning: these may erase memory values. Do not use unless you
		are confident. 
		'''
		mode = mode.lower()
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
		return _write_command('V')

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
	An   SET AUTO/MAN FOR HEATER & GAS 
	Dnnnn SET DERIVATIVE ACTION TIME 
	Fn   SET FRONT PANEL TO DISPLAY PARAMETER n 
	Gnnn SET GAS FLOW (in MANUAL only) 
	Hn   SET SENSOR FOR HEATER CONTROL 
	Innnn SET INTEGRAL ACTION TIME 
	Ln SET AUTO-PID (Learned PID's) 
	Mnnn SET MAXIMUM HEATER VOLTS LIMIT 
	Onnn SET OUTPUT VOLTS (in MANUAL only) 
	nnnn SET PROPORTIONAL BAND 
	Sn START/STOP SWEEP 
	Tnnnnn SET DESIRED TEMPERATURE

	'''
	def __init__( self ):
		return

	def set_control( self, heater, gas ):
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
		output = 'P'+input
		output = _write_command( output )
		return output

	def set_I( self, input  ):
		output = 'I'+input
		output = _write_command( output )
		return output

	def set_D( self, input  ):
		output = 'D'+input
		output = _write_command( output )
		return output

	def set_front_panel( self, input ):
		'''
		Set front panel to output a parameter other than temperature.

		Same syntax as 'R' command, Monitor.read_variable().
		'''
		output = 'F' + input
		output = _write_command( output )
		return output

	def set_gas_flow( self, input ):
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
	Y LOAD ENTIRE RAM CONTENTS 
	Z DUMP ENTIRE RAM CONTENTS
	~ STORE RAM CONTENT TO EEPROM
	! SET ISOBUS ADDRESS
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
	xnnn SET TABLE POINTER x to nnn
	ynnn SET TABLE POINTER y to nnn 
	snnnnn PROGRAM SWEEP TABLE 
	r READ SWEEP TABLE 
	w WIPE SWEEP TABLE
	pnnn PROGRAM AUTO PID TABLE PID
	q READ AUTO PID TABLE PID
	vnnn PROGRAM CUSTOM TARGET VOLTAGE TABLE
	t READ VALUE FROM TARGET VOLTAGE TABLE
	cnnn SET GAS FLOW CONFIGURATION PARAMETER
	d READ GAS FLOW CONFIGURATION PARAMETER
	m READ GAS FLOW CONTROL STATUS
	n READ TARGET VOLTS
	o READ VALVE SCALING
	'''

	def __init__( self ):
		return

	def read_sweep_table( self ):
		return _write_command( 'r' )

	def wipe_sweep_table( self ):
		return _write_command( 'w' )

	def read_autopid_table( self ):
		return _write_command( 'q' )

	def read_x_pointer(self):
		return _write_command( 't' )

	def read_gas_flow_params(self):
		return _write_command( 'd' )

	def read_flow_control(self):
		return _write_command( 'm' )

	def read_target_voltage(self):
		return write_command( 'n' )

	def read_valve_scaling(self):
		return write_command( 'o' )

	def set_pointer( self, type, value ):
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


class ICT503( Monitor, Control, System ):
	'''
	Child class for ICT503.
	'''
	def __init__( self ):
		print('Init ICT503.\n')
		return


# Some functions for common tasks.
def change_set_temperature( comdevice, comport, temp='20.00' ):
	comstring = comdevice.set_temperature( temp )
	comport.write_port( comstring )
	return

# Main script here.
comdevice = ICT503()
comport = SerialComms()

#comstring = comdevice.set_temperature('30.00')
#print(comstring)

# End of script.