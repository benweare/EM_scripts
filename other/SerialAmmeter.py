#Python Serial Communication
# Incomplete script to communicate with a picoammeter via a serial port
# requires PySerial
# python -m serial.tools.list_ports #list available ports
# 8 bits, parity = none, tx term = cr, flow = none, baud = 9600
# 0x0D, 13 = /r
# 0x0A, 10 = /n
# terminate line with \n
# uses DDC language (device dependant commands) and SCPI
import serial as serial

true = 1; false = 0
num_bytes = 100
loop_range = 1

#program to send to ammeter
write_data = '''
*IDN?;
\n
'''
bytes = write_data.encode('utf-8')

print('===start===')
ser = serial.Serial( #open port
	port='COM3', 
	baudrate=9600, 
	timeout=2, 
	write_timeout=2, 
	bytesize=serial.EIGHTBITS,
	parity=serial.PARITY_NONE
) 
	
print('Serial port: ' + ser.name) #confirm which port is used

try:
	ser.reset_input_buffer() #clear input queue
	ser.reset_output_buffer() #clear output buffer

	for x in range(loop_range):
		ser.write(write_data.encode('utf-8')) #reads bytes number of bytes
		data = ser.read(num_bytes)#reads a line termineted with /n
		print(data)
		print('decoded: ' + data.decode('utf-8') + '\n')

	ser.close() #close port

except:
	print('something went wrong')
	
	ser.close() #close port

print('==done==')