#!/bin/bash
echo "Content-type: text/html" # Tells the browser what kind of content to expect
echo "" # An empty line. Mandatory, if it is missed the page content will not load
echo "<p><em>"
echo "loading PL...<br>"
fpgautil -b design_1_wrapper.bit.bin
echo "</p></em><p>"
echo "configuring Codec...<br>"
./configure_codec.sh
echo "</p>"
echo "starting UDP Streamer Program...<br>"
./stream_udp_data 192.168.2.100 > /dev/null 2>&1 &
echo "<p><em>All Done!</em></p>" 
