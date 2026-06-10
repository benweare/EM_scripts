'''
	Python module to communicate with a Keithley picoammeter over serial port.

	Notes
	-----
	Uses DDC and SCIB languauges. Full syntax in the reference manual.


	Syntax:
	<command word> <paramater> [optional parameter]; <command word> EOI

	Must terminate program message with EOI or LF.

	Parameter types:
	<b> boolean.
	<name> Name.
	<NRf> Numeric representation format.
	<NDN> Non-decimal number.
	<n> numeric value; NRf, DEF, MIN, MAX.

	DEFault
	MINimum
	MAXumum

	0x0D, 13 = /r
	0x0A, 10 = /n
'''

import serial as serial


class GeneralBusCmds:
	'''
	Class for general bus commands.

	Not available for RS232.
	'''
	def __init__( self ):
		self.ren = 'REN'
		self.ifc = 'IFC'
		self.llo = 'LLO'
		self.gtl = 'GTL'
		self.dcl = 'DCL'
		self.sdc = 'SDC'
		self.get = 'GET'
		self.spe = 'SPE'
		self.spd = 'SPD'
		return


class CommonCmds:
	'''
	Class for common commands.
	'''
	def __init__( self ):
		self.clear_status = '*CLS'
		self.event_enable = '*ESE'
		self.event_enable_query = self.event_enable + '?'
		self.clear_status = '*ESR?'
		self.clear_status = '*IDN?'
		self.clear_status = '*OPC'
		self.clear_status = '*OPC?'
		self.clear_status = '*OPT?'
		self.clear_status = '*RCL'
		self.clear_status = '*RST'
		self.clear_status = '*SAV'
		self.clear_status = '*SRE?'
		self.clear_status = '*STB?'
		self.trigger_command = '*TRG'
		self.self_test_query = '*TST?'
		self.wait_to_continue = '*WAI'


		return

class SCPICmds:
	'''
	Class for common commands.
	'''
	def __init__( self ):
		self.calc = 'CALC' # CALC [1]
		self.calibrate = 'CAL'
		self.disp = 'DISP'
		self.format = 'FORM'
		self.sense = 'SENS'
		self.source = 'SOUR' # SOUR [1]
		self.source2 = 'SOUR2'
		self.status = 'STAT'
		self.system = 'SYST'
		self.trace = 'TRAC'
		self.trigger = 'TRIG'
		return


class SignalCmds:
	'''
	Class for common commands.
	'''
	def __init__( self ):
		self.configure = 'CONF'
		self.fetch = 'FETC'
		self.read = 'READ'
		self.measure = 'MEAS'
		return

class picoAmmeter6485_RS232(CommonCmds, SCPICmds, SignalCmds):
	'''
	Class for ammeter.
	'''
	def __init__( self ):
		self.comtype = 'RS232'
		self.EOI = 'EOI'
		self.linefeed = '\n'
		return


class picoAmmeter6485_GPIO(GeneralBusCmds, CommonCmds, SCPICmds, SignalCmds):
	'''
	Class for ammeter.
	'''
	def __init__( self ):
		self.comtype = 'GPIB'
		self.EOI = 'EOI'
		self.linefeed = '\n'
		return


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


	def test_ports( self ):
		from serial.tools import list_ports
		print(list_ports.comports())
		return


	def close_port( self ):
		self.serial_port.close( )
		return
# End.