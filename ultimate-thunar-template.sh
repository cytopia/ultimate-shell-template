#!/bin/sh -u
#
# This is a template you can use for all of your shell scripts.
# It already has many arguments and pre-checks built-int.
#
# All you have to do is:
#   1. Change all the credit variables "MY_*"
#   2. Add stuff to $REQUIRED_CUS_BIN
#   3. Edit my_thunar_custom_action() function below
#



##############################################################################################################
#                                      EDIT YOUR STUFF HERE
##############################################################################################################

#
# Credit variables
# Edit as required.
#
MY_NAME="ultimate-thunar-template.sh"
MY_DESC="At the moment does nothing :-). Add your description here"
MY_VERS="0.2"
MY_DATE="2016-06-19"
MY_LICE="MIT"
MY_AUTH="cytopia"
MY_MAIL="cytopia@everythingcli.org"

#
# The following vars are optional.
# Use empty string to ignore them
#
MY_HASH="0x695128A2" # optional
MY_PAGE="https://www.everythingcli.org" # optional
MY_GITH="https://github.com/cytopia" # optional
MY_PROJ="https://github.com/cytopia/ultimate-shell-template" # optional

#
# Custom required binaries.
# Edit as required.
#
REQUIRED_CUS_BIN="convert"




#
# This is your function to work on.
# Make sure that you must use the correct
# output and return as it currently is.
#
# @param	string	File
# @output	string	Output error or success message.
#                   This info will be displayed at the very end.
#
# @return	return	0: OK, 1: ERROR (<-- this must not change)
my_thunar_custom_action() {
	# ---- Variables ----
	_file_in="${1}"
	_file_out=""
	_ret=0


	# ---------------- Your code here ----------------

	_file_out="${_file_in}.png"

	# Get only stderr
	$(which convert) "${_file_in}" "${_file_out}" > /dev/null 2>&1
	_ret=$?

	# -------------- end of Your code here -----------



	# ---- Final section ----

	# Always output error or success information
	echo "uploaded to: http://example.com"

	# Always return the success (0: OK, 1: Error)
	return ${_ret}
}



#
# Todo: used to append to compress callback
# instead of writing to file
# e.g.: Add direct encryption
#
compress_callback() {
	echo
}




##############################################################################################################
#                                      DO NOT EDIT FROM HERE
##############################################################################################################


################################################################################
#
# VARIABLES
#
################################################################################


#
# Default required binaries
#
REQUIRED_BIN="grep sed"
REQUIRED_GUI_BIN="zenity mktemp touch cat rm"
REQUIRED_COM_BIN="tar"

EXIT_ERR=1
EXIT_OK=0

# This is used to separate space-separated arguments and
# hand them over to a function.
ARG_SEPARATOR="\n"

# Show GUI output?
HAS_GUI=0

# Be verbose?
#HAS_VER=0

# Compress
HAS_COM=0

#
# TODO:
#
#  -e exclude pattern
#  -v verbose
#  -p show progress (gui mode)
#  -q less verbose (also gui mode)
#  -l log to file
#







################################################################################
#
# STANDARD FUNCTIONS
#
################################################################################

#
# Show usage
#
print_usage() {
	echo "Usage: ${MY_NAME} [-g] [-c] -F <file>"
	echo "       ${MY_NAME} [-g] [-c] -F <dir>"
	echo "       ${MY_NAME} [-g] [-c] -F <file1> [<file2> [<file3] ...]"
	echo "       ${MY_NAME} --version"
	echo "       ${MY_NAME} --help"
	echo "       ${MY_NAME} --check"
	echo
	echo "Required options"
	echo "   -F <file>            A single file."
	echo
	echo "   -F <dir>             A single directory."
	echo
	echo "   -F <file> [<file2>]  Multiple files (must be from the same directory)."
	echo "                        You can specify as many files as you like."
	echo "                        The action is applied to each file separately."
	echo "                        However, if you add '-c', then all files are compressed first and afterwards"
	echo "                        the action is applied."
	echo "                        (See below fir description)"
	echo
	echo "Optional"
	echo "   -g                   Use gui version instead of cli."
	echo "                        Must be specified before -F to take effect."
	echo "                        Requires zenity."
	echo
	echo "   -c                   Compress all files to a single archive prior applying the desired action."
	echo
	echo "Other"
	echo "   --version            Show version information (cli-only)"
	echo
	echo "   --help               Show this help screen (cli-only)"
	echo
	echo "   --check              Check requirements and exit (cli-only)"
	echo

	if [ "${MY_PROJ}" != "" ]; then
		echo "Documentation and more info at:"
		echo "${MY_PROJ}"
	fi
}

#
# Show version information
#
print_version() {
	# Basics
	echo "Name:    ${MY_NAME}"
	echo "Version: ${MY_VERS} (${MY_DATE})"
	echo "Desc:    ${MY_DESC}"

	# Author (with or without pgp key)
	if [ "${MY_HASH}" != "" ]; then
		echo "Author:  ${MY_AUTH} ${MY_MAIL} (${MY_HASH})"
	else
		echo "Author:  ${MY_AUTH} ${MY_MAIL}"
	fi

	# License
	echo "License: ${MY_LICE}"

	# Github account
	if [ "${MY_GITH}" != "" ]; then
		echo "Github:  ${MY_GITH}"
	fi

	# Personal blog/page?
	if [ "${MY_PAGE}" != "" ]; then
		echo "Page:    ${MY_PAGE}"
	fi
}

#
# Check requirements
# System requirements and custom user requirements.
#
check_requirements() {
	_ret1=0
	_ret2=0

	# System binaries
	for _bin in ${REQUIRED_BIN}; do
		if ! command -v "${_bin}" >/dev/null 2>&1; then
			echo "[ERR] Required sys binary '${_bin}' not found."
			_ret1=1
		else
			echo "[OK]  Required sys binary '${_bin}' found."
		fi
	done

	# Custom binaries
	for _bin in ${REQUIRED_CUS_BIN}; do
		if ! command -v "${_bin}" >/dev/null 2>&1; then
			echo "[ERR] Required custom binary '${_bin}' not found."
			_ret2=1
		else
			echo "[OK]  Required custom binary '${_bin}' found."
		fi
	done

	return $((_ret1 + _ret2))
}

#
# Check GUI requirements
#
check_gui_requirements() {
	_ret=0

	for _bin in ${REQUIRED_GUI_BIN}; do
		if ! command -v "${_bin}" >/dev/null 2>&1; then
			echo "[ERR] Required GUI binary '${_bin}' not found."
			_ret=1
		else
			echo "[OK]  Required GUI binary '${_bin}' found."
		fi
	done

	return ${_ret}
}

#
# Check COM (compression) requirements
#
check_com_requirements() {
	_ret=0

	for _bin in ${REQUIRED_COM_BIN}; do
		if ! command -v "${_bin}" >/dev/null 2>&1; then
			echo "[ERR] Required compression binary '${_bin}' not found."
			_ret=1
		else
			echo "[OK]  Required compression binary '${_bin}' found."
		fi
	done

	return ${_ret}
}



################################################################################
#
# WRAPPER SYSTEM FUNCTIONS
#
################################################################################

#
# Wrapper to run shell commands safely
#
run() {
	_cmd="${1}"
	_pth="${PATH}"
	sh -c "LANG=C LC_ALL=C PATH=\"${_pth}\" ${_cmd};"
}



################################################################################
#
# NUMERIC SYSTEM FUNCTIONS
#
################################################################################

#
# Divide two numbers.
#
# @param  integer
# @param  integer
# @output integer
div() {
	_num1="${1}"
	_num2="${2}"
	echo "$(( _num1 / _num2 ))"
}


#
# Divide two numbers.
#
# @param  integer
# @param  integer
# @output integer
mul() {
	_num1="${1}"
	_num2="${2}"
	echo "$(( _num1 * _num2 ))"
}

#
# Test if argument is an integer.
#
# @param  mixed
# @return integer	0: is number | 1: not a number
isint(){
	printf "%d" "${1}" >/dev/null 2>&1 && return 0 || return 1;
}


################################################################################
#
# OTHER SYSTEM FUNCTIONS
#
################################################################################

# Create a temporary file using mktemp or touch (fallback)
#
# @output string	Full path of the created temp file
# @return integer	Success
create_tmp_file() {
	# 1st try
	if ! _file="$( run "mktemp" 2>/dev/null )"; then
		# 2nd try
		if ! _file="$( run "touch /tmp/${MY_NAME}-$(date '+%Y-%m-%d__%H-%M-%S').tmp" )"; then
			return $?
		fi
	fi
	echo "${_file}"
	return 0
}


#
# Remove empty lines
#
# @param  string	Single-/multiline string.
# @output string
remove_empty_lines() {
	echo "${1}" | run "sed '/^[[:space:]]*$/d'"
}


#
# Get all files newline separated from multiple files or folders.
#
# Will only return either:
# * one file
# * one directory
# * many files, only from within the same directory
#
# In all other cases, this function will abort with an error message (GUI or CLI).
#
# @param  string	Files/Dirs separated by \n
# @output string	See above note
# @return boolean	Succes
#
gather_files_line_by_line() {
	# Convert separated arguments into newline separation
	_args="$( echo "${*}" | run "sed 's/${ARG_SEPARATOR}/\n/g'" )"


	# Files (only files from the same directory are allowed)
	_all_files=""
	_dir_files=""

	# Directories (only 1 directory is allowed)
	_all_dirs=""
	_cnt_dirs=0

	# Invalid files/dires
	_error=""
	_errno=0

	# Set newline separator
	IFS='
	'

	# Loop over arguments
	for _file in ${_args}; do

		# Is File?
		if [ -f "${_file}" ] ; then
			if [ "${_all_files}" = "" ]; then
				_all_files="${_file}"
				_dir_files="$( dirname "${_file}" )"
			else
				if [ "$( dirname "${_file}" )" != "${_dir_files}" ]; then
					print_err "Only files from the same directory are allowed."
					exit $EXIT_ERR
				else
					_all_files="${_all_files}\n${_file}"
				fi
			fi

		# Is Directory?
		elif [ -d "${_file}" ]; then
			_all_dirs="${_all_dirs}\n${_file}"
			_cnt_dirs=$(( _cnt_dirs + 1 ))

		# Anything else, abort
		else
			_error="${_error}\n${_file}"
			_errno=1
		fi
	done


	if [ "${_errno}" != "0" ]; then
		print_err "Invalid files:\n\n${_error}"
		exit $EXIT_ERR
	fi


	# Remove empty newlines
	_all_files="$( remove_empty_lines "${_all_files}" )"
	_all_dirs="$( remove_empty_lines "${_all_dirs}" )"


	if [ "${_all_files}" != "" ] && [ "${_all_dirs}" != "" ]; then
		print_err "Mixed files and directories are not allowed."
		exit $EXIT_ERR
	fi

	# Return files
	if [ "${_all_files}" != "" ]; then
		echo "${_all_files}"
		return $EXIT_OK
	else
		if [ "${_cnt_dirs}" != "1" ]; then
			print_err "Only one directory is allowed"
			exit $EXIT_ERR
		else
			echo "${_all_dirs}"
			return $EXIT_OK
		fi
	fi
}



#
# Compress files
#
compress_files() {
	# $ARG_SEPARATOR separated arguments
	_args="${*}"

	# Error messages/counter
	_error=""
	_errno=0


	# Get all files
	_files="$( gather_files_line_by_line "${*}" )"
	_concat=""
	_parentdir=""



	# Set newline separator
	IFS='
	'
	for f in ${_files}; do
		if [ -f "${f}" ] || [ -d "${f}" ]; then

			# Note: all incoming files are in the same directory
			# that's why the dirname is always the same
			_parentdir="$( dirname "${f}" )"
			_filename="$( basename "${f}" )"

			# Get arguments separated by " to prepare for compression.
			if [ "${_concat}" = "" ]; then
				# Quote files (just in case they contain a space)
				_concat="\"${_filename}\""
			else
				# Concat and quote files (just in case they contain a space)
				_concat="${_concat} \"${_filename}\""
			fi
		else
			_error="${_error}Invalid file: ${a}\n"
			_errno="$(( _errno + 1 ))"
		fi
	done

	# Check for invalid files before compressing
	# Return error or output file
	if [ "${_errno}" != "0" ]; then
		printf "%s\n" "${_error}"
		return ${_errno}
	fi

	# Count all files
	_total="$( echo "${_files}" | run "grep -c ''" )"


	# If it is only 1 input file, we can create the archive with relative path names
	# and also store it at the same location where it has been created
	if [ "${_total}" = "1" ]; then
		# Output archive name
		# sed removes trailing directory slash
		_filename="$( echo "${_files}" | run "sed 's|/*$||'" )-$(date '+%Y-%m-%d__%H-%M-%S').tar.gz"
		_output_file="${_parentdir}/${_filename}"

		# 1 input file
		_input_files="\"${_files}\""

	# Multiple input files: quoted and concatenated
	else
		# Output archive name
		_filename="${MY_NAME}-$(date '+%Y-%m-%d__%H-%M-%S').tar.gz"
		_output_file="${_parentdir}/${_filename}"

		# Multiple input files
		_input_files="${_concat}"
	fi

	COMMAND="tar -C \"${_parentdir}\" -czf \"${_output_file}\" ${_input_files}"

	if ! run "${COMMAND}"; then
		printf "Error compressing:\n%s\n" "${COMMAND}"
		return $EXIT_ERR
	else
		printf "%s\n" "${_output_file}"
		return 0
	fi
}


################################################################################
#
# OUTPUT FUNCTIONS
#
################################################################################


#
# Output text to stdout or zenity info message
#
# @param	string	Single-/multiline string.
# @output	string
print_ok() {
	if [ "${HAS_GUI}" = "1" ] && command -v "zenity" >/dev/null 2>&1; then
		sh -c "zenity --title=\"${MY_NAME}\" --info --text=\"${*}\" 2>/dev/null"
	else
		printf "${*}%s\n" ""
	fi
}

#
# Output text to stderr or zenity error message
#
# @param	string	Single-/multiline string.
# @output	string
print_err() {
	if [ "${HAS_GUI}" = "1" ] && command -v "zenity" >/dev/null 2>&1; then
		sh -c "zenity --title=\"${MY_NAME}\" --error --text=\"Error!\n\n${*}\" 2>/dev/null"
	else
		printf "${*}%s\n" "" >&2
	fi
}


input_password() {
	_pass=""
	if [ "${HAS_GUI}" = "1" ] && command -v "zenity" >/dev/null 2>&1; then
		_pass="$(sh -c "zenity --title=\"${MY_NAME}\" --password 2>/dev/null")"
	else
		stty -echo
		read  -r _pass
		stty echo
	fi
	printf "%s\n" "${_pass}"
}





################################################################################
#
# MY CUSTOM ACTION MAIN ENTRY POINT FUNCTIONS
#
################################################################################



#
# Main GUI function
#
main_gui() {
	# $ARG_SEPARATOR separated arguments
	_args="${*}"

	# Counter
	i=0
	_err_count=0

	# Messages
	_err_files=""
	_message=""


	# Create tmpfiles files for subshell variables
	_tmp_i="$(create_tmp_file)"
	_tmp_err_count="$(create_tmp_file)"
	_tmp_err_files="$(create_tmp_file)"
	_tmp_message="$(create_tmp_file)"

	(
		# Get all files
		_files="$( gather_files_line_by_line "${*}" )"

		# Count all files
		_total="$( echo "${_files}" | run "grep -c ''" )"

		# Current counter
		i=0

		# Set newline separator
		IFS='
		'
		for f in ${_files}; do
			# Counter
			i=$((i + 1))
			# Percentage
			printf "%.0f\n" "$( div "$(mul "${i}" "100")" "${_total}" )"
			# Current file
			printf "# (%d/%d) %s\n" "${i}" "${_total}" "${f}"

			#
			# Execute action
			#
			_res="$( my_thunar_custom_action "${f}" )"
			_ret=$?

			# Concat messages
			_message="${_message}\n${_res}"


			#
			# Evaluate execution
			#
			if [ "${_ret}" != "0" ]; then
				# Increment fail count
				_err_files="${_err_files}\n${f}"
				_err_count=$((_err_count + 1))
			fi
		done

		# Store values for access outside of subshell
		echo "${i}"				> "${_tmp_i}"
		echo "${_err_count}"	> "${_tmp_err_count}"
		echo "${_err_files}"	> "${_tmp_err_files}"
		echo "${_message}"		> "${_tmp_message}"

	) |
	run "zenity --progress \
	  --auto-kill \
	  --auto-close \
	  --title=\"${MY_NAME}\" \
	  --text=\"Scanning directories...\" \
	  --percentage=0 2>/dev/null"


	# Retrieve subshell vars
	i="$( run "cat ${_tmp_i}" )"
	_err_count="$( run "cat ${_tmp_err_count}" )"
	_err_files="$( run "cat ${_tmp_err_files}" )"
	_message="$( run "cat ${_tmp_message}" )"
	# Remove subshell files
	run "rm ${_tmp_i}"
	run "rm ${_tmp_err_count}"
	run "rm ${_tmp_err_files}"
	run "rm ${_tmp_message}"


	#
	# Evaluate final program success
	#
	if [ "${_err_count}" != "0" ]; then
		print_err "${_err_count}/${i} file(s) had errors:\n\n${_err_files}\n\n${_message}"
		return $EXIT_ERR
	else
		print_ok "${i} file(s) processed successfully.\n\n${_message}"
		return $EXIT_OK
	fi
}



#
# Main CLI function
#
main_cli() {
	# $ARG_SEPARATOR separated arguments
	_args="${*}"

	# Counter
	i=0
	_err_count=0

	# Messages
	_err_files=""
	_message=""


	# Get all files
	_files="$( gather_files_line_by_line "${*}" )"

	# Count all files
	_total="$( echo "${_files}" | run "grep -c ''" )"


	# Set newline separator
	IFS='
	'
	for f in ${_files}; do
		i=$((i + 1))

		printf "(%d/%d) %s ... " "${i}" "${_total}" "${f}"

		#
		# Execute action
		#
		_res="$( my_thunar_custom_action "${f}" )"
		_ret=$?


		# Concat messages
		_message="${_message}\n${_res}"


		#
		# Evaluate execution
		#
		if [ "${_ret}" != "0" ]; then
			print_err "FAILED"

			# Increment fail count
			_err_files="${_err_files}\n${f}"
			_err_count=$((_err_count + 1))
		else
			print_ok "OK"
		fi
	done

	#
	# Evaluate final program success
	#
	if [ "${_err_count}" != "0" ]; then
		print_err "${_err_count}/${i} file(s) had errors:\n\n${_err_files}\n\n${_message}"
		return $EXIT_ERR
	else
		print_ok "${i} file(s) processed successfully.\n\n${_message}"
		return $EXIT_OK
	fi
}





################################################################################
#
# MAIN ENTRY POINT
#
################################################################################



while [ $# -gt 0  ]; do
	case "${1}" in


		# ---- FINAL MAIN ENTRY POINT ----
		-F)

			# Check system requirements (sys and custom)
			if ! _error_requirements="$(check_requirements)"; then
				print_err "${_error_requirements}"
				exit $EXIT_ERR
			fi


			# Shift `-F` away to get all files/dirs after '-F'
			shift


			# Get arguments separated by a non-space value,
			# otherwise we cannot distinguish between arguments
			# with space inside (when passed to a function)
			ARGS=""
			for a in "$@"; do
				if [ "${ARGS}" = "" ]; then
					ARGS="${a}"
				else
					# Add new separator (newline) to distinguish between
					# space separated filenames and new arguments.
					ARGS="${ARGS}${ARG_SEPARATOR}${a}"
				fi
			done

			# Compress?
			# This returns the compressed file on success
			# or the error message on failure
			if [ "${HAS_COM}" = "1" ]; then

				# GUI Version
				if [ "${HAS_GUI}" = "1" ]; then
					_tmp_file_out="$( create_tmp_file )"
					_tmp_file_ret="$( create_tmp_file )"

					( compress_files "${ARGS}" > "${_tmp_file_out}"; echo $? > "${_tmp_file_ret}"; ) |  \
						zenity --progress \
						--auto-close \
						--auto-kill \
						--pulsate \
						--title="${MY_NAME}" \
						--text="Compressing files..." 2>/dev/null

					_ret1=$?
					_ret2="$( run "cat ${_tmp_file_ret}" )"

					ARGS="$( run "cat ${_tmp_file_out}" )"
					run "rm ${_tmp_file_out}"
					run "rm ${_tmp_file_ret}"

					if [ "${_ret1}" != "0" ] || [ "${_ret2}" != "0" ]; then
						print_err "${ARGS}"
						exit $EXIT_ERR
					fi
				# CLI version
				else
					printf "Compressing files... "
					if ! ARGS="$( compress_files "${ARGS}" )"; then
						print_err "FAILED"
						print_err "${ARGS}"
						exit ${EXIT_ERR}
					fi
					print_ok "OK"
				fi
  			fi


			if [ "${HAS_GUI}" = "1" ]; then
				main_gui "${ARGS}"
				exit $?
			else
				main_cli "${ARGS}"
				exit $?
			fi
			;;



		# ---- Enable Compress Mode ----
		-c)
			# Check compression requirements
			if ! ERROR="$( check_com_requirements )"; then
				print_err "${ERROR}"
				exit ${EXIT_ERR}
			fi

			HAS_COM=1
			;;


		# ---- Enable GUI mode ----
		-g)
			# Make sure GUI requirements are met.
			if ! ERROR="$( check_gui_requirements )"; then
				print_err "${ERROR}"
				exit ${EXIT_ERR}
			fi

			HAS_GUI=1
			;;


		# ---- Show help ----
		--help)
			print_usage
			exit ${EXIT_OK}
			;;

		# ---- Show version ----
		--version)
			print_version
			exit ${EXIT_OK}
			;;

		# ---- Check requirements ----
		--check)
			_ret=0
			_cnt=0
			check_requirements
			_ret=$?
			_cnt=$((_cnt + _ret))
			check_com_requirements
			_ret=$?
			_cnt=$((_cnt + _ret))
			check_gui_requirements
			_ret=$?
			_cnt=$((_cnt + _ret))
			exit ${_ret}
			;;

		# ---- Invalid argument ----
		*)
			print_err "Invalid argument: '${1}'.\nType '${MY_NAME} --help' for available options."
			exit ${EXIT_ERR}
			;;
	esac
	shift
done


# Missing argument: -F
print_err "Missing argument '-F'.\nType '${MY_NAME} --help' for available options."
exit ${EXIT_ERR}


