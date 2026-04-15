#! /usr/bin/python3
import cgi, os

# Create instance of FieldStorage
form = cgi.FieldStorage()

# Get data from fields
adc_freq_hz  = int(form.getvalue('adc_freq_hz'))
tune_freq_hz  = int(form.getvalue('tune_freq_hz'))
streaming = form.getvalue('streaming')

CPU_CLOCK_FREQUENCY = 125e6
NUM_PHASE_VALUES = (1 << 27)

# Send the result to the browser
print ("Content-type:text/html")
print()
print ("<html>")
print ('<head>')
print ("<title>Radio Configurator</title>")
print ('</head>')
print ('<body>')
print ("<h2>Radio Configurator</h2>")
print ("Setting up the radio now...")
print ("ADC Freq = %d, Tune Freq = %d" %(adc_freq_hz,tune_freq_hz))
adc_phase_offset = int(round(adc_freq_hz * NUM_PHASE_VALUES / CPU_CLOCK_FREQUENCY))
tuner_phase_offset = int(round(tune_freq_hz * NUM_PHASE_VALUES / CPU_CLOCK_FREQUENCY))
os.system(f"devmem 0x43c00000 w {adc_phase_offset}")
os.system(f"devmem 0x43c00004 w {tuner_phase_offset}")
if (streaming == "streaming"):
    print ("streaming is Enabled<br>")
    os.system(f"devmem 0x43c00008 w 2")
else :
    print ("streaming is Disabled<br>")
    os.system(f"devmem 0x43c00008 w 0")
print ('</body>')
print ('</html>')

