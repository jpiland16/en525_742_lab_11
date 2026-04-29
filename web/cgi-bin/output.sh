PREVIOUS_STREAMING_FLAG=$(( $(devmem 0x43c00008) & 2))

if [ $PREVIOUS_STREAMING_FLAG == 2 ]; then
    NOTE_OFF=0x00000003
    NOTE_ON=0x00000002
else
    NOTE_OFF=0x00000001
    NOTE_ON=0x00000000
fi

echo "previous streaming flag is $PREVIOUS_STREAMING_FLAG"
echo "note on word is $NOTE_ON"
echo "note off word is $NOTE_OFF"

devmem 0x43c00000 w 0x00000229
devmem 0x43c00004 w 0x0000009b
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x00000229
devmem 0x43c00004 w 0x0000009b
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x00000229
devmem 0x43c00004 w 0x0000009b
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x000001e0
devmem 0x43c00004 w 0x00000052
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x00000229
devmem 0x43c00004 w 0x0000009b
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.177
devmem 0x43c00000 w 0x000002ae
devmem 0x43c00004 w 0x0000009c
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.497
devmem 0x43c00000 w 0x000001a5
devmem 0x43c00004 w $NOTE_ON
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.496
devmem 0x43c00000 w 0x000001ca
devmem 0x43c00004 w 0x00000068
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.336
devmem 0x43c00000 w 0x0000015f
devmem 0x43c00004 w 0x00000046
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.336
devmem 0x43c00000 w 0x0000011a
devmem 0x43c00004 w 0x00000048
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.336
devmem 0x43c00000 w 0x00000179
devmem 0x43c00004 w 0x00000060
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x000001a7
devmem 0x43c00004 w 0x0000006b
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x0000018f
devmem 0x43c00004 w 0x00000065
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x00000179
devmem 0x43c00004 w 0x00000060
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x0000015f
devmem 0x43c00004 w 0x00000046
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.095
devmem 0x43c00000 w 0x00000234
devmem 0x43c00004 w 0x0000008f
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.055
devmem 0x43c00000 w 0x000002ae
devmem 0x43c00004 w 0x0000009c
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.057
devmem 0x43c00000 w 0x000002f1
devmem 0x43c00004 w 0x000000c0
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.177
devmem 0x43c00000 w 0x00000263
devmem 0x43c00004 w 0x0000008b
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.017
devmem 0x43c00000 w 0x000002ae
devmem 0x43c00004 w 0x0000009c
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x0000024e
devmem 0x43c00004 w 0x00000076
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x000001ca
devmem 0x43c00004 w 0x00000068
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000001f7
devmem 0x43c00004 w 0x00000080
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000001a7
devmem 0x43c00004 w 0x0000006b
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.336
devmem 0x43c00000 w 0x000001ca
devmem 0x43c00004 w 0x00000068
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.336
devmem 0x43c00000 w 0x0000015f
devmem 0x43c00004 w 0x00000046
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.336
devmem 0x43c00000 w 0x0000011a
devmem 0x43c00004 w 0x00000048
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.336
devmem 0x43c00000 w 0x00000179
devmem 0x43c00004 w 0x00000060
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x000001a7
devmem 0x43c00004 w 0x0000006b
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x0000018f
devmem 0x43c00004 w 0x00000065
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x00000179
devmem 0x43c00004 w 0x00000060
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x0000015f
devmem 0x43c00004 w 0x00000046
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.096
devmem 0x43c00000 w 0x00000234
devmem 0x43c00004 w 0x0000008f
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.055
devmem 0x43c00000 w 0x000002ae
devmem 0x43c00004 w 0x0000009c
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.057
devmem 0x43c00000 w 0x000002f1
devmem 0x43c00004 w 0x000000c0
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.177
devmem 0x43c00000 w 0x00000263
devmem 0x43c00004 w 0x0000008b
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.017
devmem 0x43c00000 w 0x000002ae
devmem 0x43c00004 w 0x0000009c
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x0000024e
devmem 0x43c00004 w 0x00000076
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x000001ca
devmem 0x43c00004 w 0x00000068
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000001f7
devmem 0x43c00004 w 0x00000080
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000001a7
devmem 0x43c00004 w 0x0000006b
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.656
devmem 0x43c00000 w 0x00000307
devmem 0x43c00004 w 0x00000043
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000002db
devmem 0x43c00004 w 0x0000003f
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000002b2
devmem 0x43c00004 w 0x0000003c
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x00000257
devmem 0x43c00004 w 0x00000045
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x0000027b
devmem 0x43c00004 w 0x00000049
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x00000190
devmem 0x43c00004 w 0x0000002e
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000001a8
devmem 0x43c00004 w 0x00000031
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000001eb
devmem 0x43c00004 w 0x00000046
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.177
devmem 0x43c00000 w 0x00000179
devmem 0x43c00004 w 0x00000060
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.017
devmem 0x43c00000 w 0x000001ca
devmem 0x43c00004 w 0x00000068
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.017
devmem 0x43c00000 w 0x000001f7
devmem 0x43c00004 w 0x00000080
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.337
devmem 0x43c00000 w 0x00000307
devmem 0x43c00004 w 0x00000043
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000002db
devmem 0x43c00004 w 0x0000003f
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000002b2
devmem 0x43c00004 w 0x0000003c
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x00000257
devmem 0x43c00004 w 0x00000045
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x0000027b
devmem 0x43c00004 w 0x00000049
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x000003a9
devmem 0x43c00004 w 0x000000bb
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x000003a9
devmem 0x43c00004 w 0x000000bb
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000003a9
devmem 0x43c00004 w 0x000000bb
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.816
devmem 0x43c00000 w 0x00000307
devmem 0x43c00004 w 0x00000043
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000002db
devmem 0x43c00004 w 0x0000003f
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000002b2
devmem 0x43c00004 w 0x0000003c
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x00000257
devmem 0x43c00004 w 0x00000045
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x0000027b
devmem 0x43c00004 w 0x00000049
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.176
devmem 0x43c00000 w 0x00000190
devmem 0x43c00004 w 0x0000002e
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000001a8
devmem 0x43c00004 w 0x00000031
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.016
devmem 0x43c00000 w 0x000001eb
devmem 0x43c00004 w 0x00000046
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.177
devmem 0x43c00000 w 0x00000179
devmem 0x43c00004 w 0x00000060
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.017
devmem 0x43c00000 w 0x000001ca
devmem 0x43c00004 w 0x00000068
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.017
devmem 0x43c00000 w 0x000001f7
devmem 0x43c00004 w 0x00000080
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.337
devmem 0x43c00000 w 0x0000022d
devmem 0x43c00004 w 0x0000006f
devmem 0x43c00008 w $NOTE_ON
sleep 0.095
devmem 0x43c00008 w $NOTE_OFF
sleep 0.336
devmem 0x43c00000 w 0x000001f7
devmem 0x43c00004 w 0x00000080
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.336
devmem 0x43c00000 w 0x000001ca
devmem 0x43c00004 w 0x00000068
devmem 0x43c00008 w $NOTE_ON
sleep 0.096
devmem 0x43c00008 w $NOTE_OFF
sleep 0.026
echo Done!
