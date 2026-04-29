#!/bin/bash
echo "Content-type: text/html" # Tells the browser what kind of content to expect
echo "" # An empty line. Mandatory, if it is missed the page content will not load
killall stream_udp_data
echo "<p><em>"
echo "loading PL...<br>"
fpgautil -b design_1_wrapper.bit.bin
echo "</p></em><p>"
echo "configuring Codec...<br>"
./configure_codec.sh
echo "</p>"
echo "starting UDP Streamer Program...<br>"
REMOTE_IP=$(echo $REMOTE_ADDR | cut -d: -f4 | cut -d\] -f1)
echo "Your IP address is: $REMOTE_IP (this is where UDP will stream to)"
./stream_udp_data $REMOTE_IP > /dev/null 2>&1 &
echo "<p><em>All Done!</em></p>" 
