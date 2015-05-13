#!/bin/bash - 
#===============================================================================
#
#          FILE:  install-polymer-environment.sh
# 
#         USAGE:  1. Copy entire "GDGPolymer" folder in Home Folder (~/).
#		  2. Go to ~/GDGPolymer/scripts/
#		  3. Execute the shell script as: sh install-polymer-environment.sh 
# 
#   DESCRIPTION:  Installs environment to run Polymer.
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: ANUJ DUGGAL
#       LICENCE: Copyright (c) 2015, ANUJ DUGGAL
#       COMPANY: 
#       CREATED: Sunday 19 April 2015 11:50:05  IST IST
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# DIRECTORIES:
HOME=~/
POLYMER=~/polymer1234
ERROR_FILE="error_logs.txt"
ERROR_LOGS=$POLYMER/$ERROR_FILE
GDGPOLYMER=~/GDGPolymer
SCRIPTS=$GDGPOLYMER/scripts
PACKAGES=$GDGPOLYMER/packages
CUSTOM_ELEMENTS=$POLYMER/custom-elements
CUSTOM_ELEMENT_FILE="custom-element.html"
INDEX_FILE="index.html"
CUSTOM_ELEMENTS_TEMPLATE=$GDGPOLYMER/packages/$CUSTOM_ELEMENT_FILE
INDEX_FILE_TEMPLATE=$GDGPOLYMER/packages/$INDEX_FILE

# PACKAGES:
INSTALL_BOWER="sudo npm install -g bower"

# COMMANDS:
INITIATE_BOWER="bower init"
INSTALL_POLYMER_REPOSITORY="bower install --save Polymer/polymer"
UPDATE_BOWER="bower update"
INSTALL_GIT="sudo apt-get install git"
UNTAR_NODEJS="tar -zxvf node-v0.12.2.tar.gz"

# SYSTEM DETAILS:
DATETIMESTAMP=$(date "+%m-%d-%Y-%H-%M-%S")
BASENAME=$(echo $(basename $0) | cut -f1 -d '.')

# LOGGING:
LOG="/tmp/$BASENAME-$DATETIMESTAMP.log"

print_log() {
	echo $(date "+%H:%M:%S") $1 '|' $2 | tee -a $LOG
}

# SETTING UP DIRECTORY STRUCTURE:
setup_dir(){

	print_log "INFO" "Setting up Directory structure for Polymer.."

	mkdir $POLYMER
	if [ $? -ne 0 ]
	then
		print_log "ERROR" "Failed to create polymer Directory. Aborting further installation."
		echo "ERROR | Failed to create polymer Directory. Aborting further installation." >> $ERROR_LOGS
		exit 1
	else
		print_ilog "INFO" "Polymer Directory created successully."

		# CREATE CUSTOM TEMPLATE FOLDER:
		cd $POLYMER
		mkdir $CUSTOM_ELEMENTS
		if [ $? -ne 0 ]
		then
			print_log "ERROR" "Failed to create Custom Element folder."
			echo "ERROR | Failed to create Custom Element folder." >> $ERROR_LOGS
		else
			print_log "INFO" "Custom Element folder created successully."

			cp $CUSTOM_ELEMENTS_TEMPLATE $CUSTOM_ELEMENTS
			if [ $? -ne 0 ]
			then
				print_log "ERROR" "Failed to copy custom-element."
				echo "ERROR | Failed to copy custom-element." >> $ERROR_LOGS
			else
				print_log "INFO" "Custom Element template copied successfully."
			fi
		fi

		# COPY index.html from packages folder:
		cp $INDEX_FILE_TEMPLATE $POLYMER
		if [ $? -ne 0 ]
		then
			print_log "ERROR" "Failed to copy index.html."
			echo "ERROR | Failed to copy index.html." >> $ERROR_LOGS
		else
			print_log "INFO" "index.html template copied successfully."
		fi
	fi

}


# INSTALL REQUIRED PACKAGES:
install_packages(){

	print_log "INFO" "Installing Requierd Packages.."

	# INSTALL NODEJS:
	# UNSTAR THE PACKAGE:
	cd $PACKAGES
	$UNTAR_NODEJS
	if [ $? -ne 0 ]
	then
		print_log "ERROR" "Failed to untar nodejs package. Aborting further installation."
		echo "ERROR | Failed to untar nodejs package. Aborting further installation." >> $ERROR_LOGS
		exit 1
	else
		print_log "INFO" "nodejs package is un-tarred successully."
	fi


	# CHANGE DIRECTORY TO POLYMER:
	cd $POLYMER

	#INSTALL GIT
	$INSTALL_GIT
	if [ $? -ne 0 ]
	then
		print_log "ERROR" "Failed to install Git. Aborting further installation."
		echo "ERROR | Failed to install Git. Aborting further installation." >> $ERROR_LOGS
		exit 1
	else
		print_log "INFO" "Git installed successully."
	fi

	# INSTALL BOWER:
	$INSTALL_BOWER
	if [ $? -ne 0 ]
	then
		print_log "ERROR" "Failed to install Bower. Aborting further installation."
		echo "ERROR | Failed to install Bower. Aborting further installation." >> $ERROR_LOGS
		exit 1
	else
		print_log "INFO" "Bower installed successully."
	fi
}


# CLONE POLYMER:
clone_polymer(){

	# CHANGE DIRECTORY TO POLYMER:
	cd $POLYMER

	# INSTALL BOWER:
	$INITIATE_BOWER

	# INITIALIZE POLYMER REPO:
	$INSTALL_POLYMER_REPOSITORY
	if [ $? -ne 0 ]
	then
		print_log "ERROR" "Failed to clone Polymer repository. Try again."
		echo "ERROR | Failed to clone Polymer repository. Try again." >> $ERROR_LOGS
	else
		print_log "INFO" "Polymer repository initialized successfully."
	fi

	# UPDATE BOWER:
	$UPDATE_BOWER
}


# SETTING UP ENVIRONMENT:
setup_environment(){

	print_log "INFO" "Setting up Polymer Environment.."

	# CHECK IF POLYMER DIRECTORY ALREADY EXISTS:
	if [ ! -x $POLYMER ]
	then
		# SETUP POLYMER DIRECTORY:
		setup_dir
	else
		print_log "WARNING" "POLYMER Directory already exists. Aborting Installation. Delete already existing Polymer folder for fresh installation."
		exit 1
	fi

	# TODO: INSTALL REQUIRED PACKAGES:
	install_packages

	# TODO: CLONE POLYMER REPOSITORY:
	clone_polymer
}

# INSTALL:
setup_environment
