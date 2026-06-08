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
		mode = lower(mode)
		if mode == 'local' and locked == True:
			output = 'C0'
		if mode == 'remote' and locked == True:
			output = 'C1'
		if mode == 'local' and locked == False:
			output = 'C2'
		if mode == 'remote' and locked == False:
			output = 'C3'
		return output

	def set_comm_protocol( self, mode ):
		mode = lower(mode)
		if mode == 'normal':
			output = 'Q0'
		else:
			output = 'Q1'
		return output

	def set_unlock( self, mode ):
		'''
		Warning: these may erase memory values. Do not use unless you
		are confident. 
		'''
		mode = lower(mode)
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
		return

	def read_version( self ):
		return 'V'

	def set_wait( self, delay=1000 ):
		'''
		Delay in miliseconds, formatted as 'nnnn'
		'''
		output = 'W'+ str(delay)
		return output

	def examine(self, ):
		output = 'X'
		return output


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
		heater = lower(heater)
		gas = lower(gas)
		if heater == 'manual' and gas == 'manual':
			output = 'A0'
		if heater == 'auto' and gas == 'auto':
			output = 'A1'
		if heater == 'manual' and gas == 'manual':
			output = 'A2'
		if heater == 'auto' and gas == 'auto':
			output = 'A3'
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
		return output

	def _dump_RAM( self, kilobytes=8 ):
		output = 'Z'+str(kilobytes)
		return output

	def _store_RAM_to_EEPROM( self, kilobytes=8 ):
		output = '~'
		return output

	def _set_isobus_address():
		# section 10.5 of manual
		return

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
		return 'r'

	def wipe_sweep_table( self ):
		return 'w'

	def read_autopid_table( self ):
		return 'q'

	def read_x_pointer(self):
		return 't'

	def read_gas_flow_params(self):
		return 'd'

	def read_flow_control(self):
		return 'm'

	def read_target_voltage(self):
		return 'n'

	def read_valve_scaling(self):
		return 'o'

	def set_pointer( self, type, value ):
		'''
		type : string
			x, or y. 
		value : string
			0 to 128
		'''
		output = type + string
		return output

	def set_sweep_table(self):
		return

	def set_autopid_table(self):
		return

	def set_heater_voltage_table(self):
		return


class ICT503( Monitor, Control, System ):
	'''
	Child class for ICT503.
	'''
	def __init__( self):
		print('Init ICR503.\n')
		return

# Main script here.

device = ICT503()

comms = SerialComms()

comms.test_ports()

# End of script.