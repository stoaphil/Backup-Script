#!/usr/bin/env bash

# Program to backup from an HDD to a flash drive or vice-versa.
# The flash drive must be mounted first to /mnt/flash.
# On OBSD, need to run in BASH shell; check with "echo "$0"".  ACTUALLY, seems to
# run fine in ksh; probably calling bash with the shabang above?

# On 11/6/16, on Fedora, changed from rluvpt to -avu --delete; also for unknown reason had
# added a -K option only to the bin dir; not sure why, so did not preserve at this point.
# May have been to attempt to correct symlink errors on Kerrisk dir???

# Note that the fat filesystem does not preserve permission, and has trouble with timestamps;
# this is why all files get the execute bit set.

# Resolved: use ext2, which works on Linux and OpenBSD

# Substantive options are seperate functions:

HDD_to_flash () {

	[[ -d /mnt/flash/CONFIGURATION ]] && $(rsync -rlptgouv --delete /home/dutch/CONFIGURATION/ /mnt/flash/CONFIGURATION) 2>/dev/null
	[[ -d /mnt/flash/Documents ]] && $(rsync -rlptgouv --delete /home/dutch/Documents/ /mnt/flash/Documents) 2>/dev/null
	[[ -d /mnt/flash/Pictures ]] && $(rsync -rlptgouv --delete /home/dutch/Pictures/ /mnt/flash/Pictures) 2>/dev/null
	[[ -d /mnt/flash/Rental ]] && $(rsync -rlptgouv --delete /home/dutch/Rental/ /mnt/flash/Rental) 2>/dev/null
	[[ -d /mnt/flash/asm ]] && $(rsync -rlptgouv --delete /home/dutch/asm/ /mnt/flash/asm) 2>/dev/null
	[[ -d /mnt/flash/bin ]] && $(rsync -rlptgouv --delete /home/dutch/bin/ /mnt/flash/bin) 2>/dev/null

	if [[ -d /home/dutch/NOTES ]] && [[ -d /mnt/flash/notes ]]; then
		$(rsync -rlptgouv --delete /home/dutch/NOTES/ /mnt/flash/notes) 2>/dev/null
	elif [[ -d /home/dutch/NOTES ]] && [[ -d /mnt/flash/NOTES ]]; then
		$(rsync -rlptgouv --delete /home/dutch/NOTES/ /mnt/flash/NOTES) 2>/dev/null
	elif [[ -d /home/dutch/notes ]] && [[ -d /mnt/flash/notes ]]; then
		$(rsync -rlptgouv --delete /home/dutch/notes/ /mnt/flash/notes) 2>/dev/null
	fi

	return
}


flash_to_HDD () {

	[[ -d /mnt/flash/CONFIGURATION ]] && $(rsync -rlptgouv --delete /mnt/flash/CONFIGURATION/ /home/dutch/CONFIGURATION) 2>/dev/null
	[[ -d /mnt/flash/Documents ]] && $(rsync -rlptgouv --delete /mnt/flash/Documents/ /home/dutch/Documents) 2>/dev/null
	[[ -d /mnt/flash/Pictures ]] && $(rsync -rlptgouv --delete /mnt/flash/Pictures/ /home/dutch/Pictures) 2>/dev/null
	[[ -d /mnt/flash/Rental ]] && $(rsync -rlptgouv --delete /mnt/flash/Rental/ /home/dutch/Rental) 2>/dev/null
	[[ -d /mnt/flash/asm ]] && $(rsync -rlptgouv --delete /mnt/flash/asm/ /home/dutch/asm) 2>/dev/null
	[[ -d /mnt/flash/bin ]] && $(rsync -rlptgouv --delete /mnt/flash/bin/ /home/dutch/bin) 2>/dev/null

	if [[ -d /home/dutch/NOTES ]] && [[ -d /mnt/flash/notes ]]; then
		$(rsync -rlptgouv --delete /mnt/flash/NOTES/ /home/dutch/notes) 2>/dev/null
	elif [[ -d /home/dutch/NOTES ]] && [[ -d /mnt/flash/NOTES ]]; then
		$(rsync -rlptgouv --delete /mnt/flash/NOTES/ /home/dutch/NOTES) 2>/dev/null
	elif [[ -d /home/dutch/notes ]] && [[ -d /mnt/flash/notes ]]; then
		$(rsync -rlptgouv --delete /mnt/flash/notes/ /home/dutch/notes) 2>/dev/null
	fi

	return
}

# Menu of options:

ERR_ADVISE="The flash drive is not mounted."

if [[ -d /mnt/flash/bin ]]; then	#does not work with /mnt/flash/* but should; maybe because * expands directories?  (would not then be -d)
									#also reversing the if...then order and using [[ ! ...
									#did not work but should

	clear
	cat <<- EOF
		Please Select:

		0. Quit
		1. Backup from HDD to flash
		2. Backup from flash to HDD
	EOF

	read -p "Enter Selection [0-2] -> "

	case $REPLY in

		0)		echo "Program Terminated."
				exit
				;;
		1)		echo "Copying...."
				HDD_to_flash
				echo "Successful sync"
				;;
		2)		echo "Copying...."
				flash_to_HDD
				echo "Successful sync"
				;;
		*)		echo "Invalid entry" >&2
				exit 1
				;;
	esac
else
	echo "$ERR_ADVISE"
	exit 100

fi
exit 0


# Can test mount this way as well:
# a=$(cd /mnt/flash/bin 2>/dev/null; echo "$?")
# if [[ $a == 1 ]]; then echo ERROR; else echo SUCCESS; fi
# or use (($a == 1)) - both seem to work - which is better?
