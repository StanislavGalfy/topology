# Translate a text string to a series of qemu sendkey commands
# and send it to a qemu monitor
monitor_cmd () {
	{
		echo "$1" | fold -w 1 | sed \
			-e 's/ /spc/' \
			-e 's/\./dot/' \
			-e 's/-/minus/' \
			-e 's/+/shift-equal/' \
			-e 's/_/shift-minus/' \
			-e 's/@/shift-2/' \
			-e 's/:/shift-semicolon/' \
			-e 's/\//slash/' \
			-e 's/=/equal/' \
			-e 's/|/shift-backslash/' \
			-e 's/\([[:upper:]]\)/shift-\L\1/' \
			-e 's/\\/backslash/' |
			while read code; do
				echo "sendkey $code" >> log.txt
				echo "sendkey $code"
			done
		echo "sendkey ret"
	} | socat STDIN UNIX-CONNECT:/tmp/monitor-$2
}

# Send a raw key code to a qemu monitor
monitor_key () {
	echo "sendkey $1" | socat STDIN UNIX-CONNECT:$TMP/monitor-$2
}

# Count occurences of the # character on the standard input
hashcount () {
	cat | grep -o '#' | wc -l
}

monitor_cmd './run-bird.sh' coreB

monitor_cmd 'batch run-birdA.sh' helenosA
monitor_cmd 'batch run-birdA1.sh' helenosA1
monitor_cmd 'batch run-birdA2.sh' helenosA2

monitor_cmd 'batch run-birdB1.sh' helenosB1
monitor_cmd './run-bird.sh' coreB2

monitor_cmd 'batch run-birdC.sh' helenosC
monitor_cmd 'batch run-birdC1.sh' helenosC1
monitor_cmd './run-bird.sh' coreC2
