#!/bin/sh -u
#
# This is a template you can use for all of your shell scripts.
# It already has many arguments and pre-checks built-int.
#
# All you have to do is:
#   1. Change all the credit variables "MY_*"
#   2. Add stuff to $REQUIRED_CUS_BIN
#   3. Edit my_custom_action() function below
#


################################################################################
#
# VARIABLES FOR EDITING
#
################################################################################

#
# Credit variables
# Edit as required.
#
MY_NAME="ultimate-shell-template"
MY_DESC="At the moment does nothing :-). Add your description here"
MY_VERS="0.2"
MY_DATE="2016-06-19"
MY_LICE="MIT"
MY_AUTH="cytopia"
MY_MAIL="cytopia@everythingcli.org"
# The following vars are optional.
# Use empty string to ignore them
MY_HASH="0x695128A2" # optional
MY_PAGE="https://www.everythingcli.org" # optional
MY_GITH="https://github.com/cytopia" # optional
MY_PROJ="https://github.com/cytopia/ultimate-shell-template" # optional


#
# Custom required binaries.
# Edit as required.
#
REQUIRED_CUS_BIN="convert"





################################################################################
#
# VARIABLES (Do not edit)
#
################################################################################


#
# Default required binaries
#
#REQUIRED_BIN="sed wc awk tar gzip find"
REQUIRED_BIN="grep sed tar gzip find"
REQUIRED_GUI_BIN="zenity"

EXIT_ERR=1
EXIT_OK=0

# This is used to separate space-separated arguments and
# hand them over to a function.
# Probably has problems with '|' in the filename.
# TODO: Further investigate better possibilities.
ARG_SEPARATOR="|"

#
# Default command line argument values
#

# Show GUI output?
HAS_GUI=0

# Recurse into directories?
HAS_REC=0

# Level of recursions
# 0: no limit
# 1: one level (current files only)
# 2: ...
LVL_REC=0





#
# TODO:
#
#  -e exclude pattern
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
	echo "Usage: ${0} [-g] [-r <num>] -f <file> [<file2> [<directory>]...]"
	echo "       ${0} [-g] -c <file> [<file2> [<directory>]...]"
	echo "       ${0} --version"
	echo "       ${0} --help"
	echo "       ${0} --check"
	echo
	echo "Required options"
	echo "   -f <file> [<dir>]   This option processes each file separately!"
	echo
	echo "                       You can specify as many files and/or directories as you like."
	echo "                       Prior executing, all files are gathered and then the action is applied."
	echo "                       If you also specified directories, they will be traversed"
	echo "                       to a level as specified by '-r' (see below) and all found files will"
	echo "                       be gathered as well."
	echo "                       Note: You must really specify '-r' to actually recurse into directories."
	echo
	echo
	echo "   -c <file> [<dir>]   This option compressed everything first and then processes the final *.tar.gz!"
	echo
	echo "                       Specify one or more files and/or directories."
	echo
	echo
	echo "Optional"
	echo "   -g                  Use gui version instead of cli."
	echo "                       Must be specified before -f to take effect."
	echo "                       Requires zenity."
	echo
	echo "   -r <num>            Be recursive (only works with '-f' option)."
	echo "                       If you do not specify '-r X', no directories are being traversed."
	echo "                       Examples:"
	echo "                       '-r 0' will recurse into all subdirectories indefinitely."
	echo "                       '-r 1' all files inside the directory."
	echo "                       '-r 2' all files inside this and all files inside subdirectories."
	echo "                       '-r 3' Three levels of recursion."
	echo
	echo "Other"
	echo "   --version           Show version information (cli-only)"
	echo
	echo "   --help              Show this help screen (cli-only)"
	echo
	echo "   --check             Check requirements and exit (cli-only)"
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


################################################################################
#
# WRAPPER SYSTEM FUNCTIONS
#
################################################################################

run() {
	_cmd="${1}"
	_pth="${PATH}"
	sh -c "LANG=C LC_ALL=C PATH=\"${_pth}\" ${_cmd}"
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
	#echo | $(which awk) -v "a=${1}" -v "b=${2}" '{print a / b}'
	#echo | sh -c "awk -v 'a=${1}' -v 'b=${2}' '{print a / b}'"
	#echo | run "awk -v 'a=${1}' -v 'b=${2}' '{print a / b}'"
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
	#echo | $(which awk) -v "a=${1}" -v "b=${2}" '{print a * b}'
	#echo | sh -c "awk -v 'a=${1}' -v 'b=${2}' '{print a * b}'"
	#echo | run "awk -v 'a=${1}' -v 'b=${2}' '{print a * b}'"
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



#
# Remove empty lines
#
# @param  string	Single-/multiline string.
# @output string
remove_empty_lines() {
	_lines="${1}"
	#echo "${_lines}" | $(which sed) '/^\s*$/d'
	echo "${_lines}" | run "sed '/^[[:space:]]*$/d'"
}


#
# Get all files newline separated from multiple files or folders
#
gather_files_line_by_line() {
	# Convert separated arguments into newline separation
	#_args="$( echo "${*}" | $(which sed) "s/${ARG_SEPARATOR}/\n/g" )"
	#_args="$( echo "${*}" | sh -c "sed 's/${ARG_SEPARATOR}/\n/g'" )"
	_args="$( echo "${*}" | run "sed 's/${ARG_SEPARATOR}/\n/g'" )"



	_all_files=""

	# Set newline separator
	IFS='
	'

	# Loop over arguments
	for _file in ${_args}; do

		# If directory, recurse
		if [ -d "${_file}" ] && [ "${HAS_REC}" = "1" ]; then

			if [ "${LVL_REC}" = "0" ]; then
				_all_files="${_all_files}\n$( $(which find) "${_file}" -not -path '*/\.*' -type f \( ! -iname ".*" \) )"
			else
				_all_files="${_all_files}\n$( $(which find) "${_file}" -maxdepth ${LVL_REC}  -not -path '*/\.*' -type f \( ! -iname ".*" \) )"
			fi

			#for f in ${_file}/*; do
			#	_all_files="${_all_files}\n$( gather_files_line_by_line "${f}" )"
			#done
		else
			_all_files="${_all_files}\n${_file}"
		fi
	done

	# Remove empty lines
	remove_empty_lines "${_all_files}"
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
		sh -c "zenity --title=\"${MY_NAME}\" --error --text=\"${*}\" 2>/dev/null"
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
# MY CUSTOM ACTION FUNCTIONS (EDIT THIS ONE)
#
################################################################################

#
# This is your function to work on.
# Make sure that you must use the correct
# output and return as it currently is.
#
# @param	string	File
# @output	string	It MUST output the new filepath (if a new file was generated)
#                   If no new file was generated, it must output the input filepath.
#
# @return	return	0: OK, 1: ERROR (<-- this must not change)
#
my_custom_action() {
	# ---- Variables ----
	_file_in="${1}"
	_file_out=""
	_ret=0



	# ---------------- Your code here ----------------

	_file_out="${1}.png"

	# Get only stderr
	$(which convert) "${_file_in}" "${_file_out}" > /dev/null 2>&1
	_ret=$?

	# -------------- end of Your code here -----------




	# ---- Final section ----

	# Always output the new file (if new file has been generated)
	# or the input file (if no new file has been generated)
	#echo "${_file_in}"
	echo "${_file_out}"

	# Always return the success (0: OK, 1: Error)
	return ${_ret}
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

	# Error messages/counter
	_err_files=""
	_err_cnt=0
	_error=""

	# Sys requirements checks
	_error_requirements="$(check_requirements)"
	_errno_requirements=$?
	if [ "${_errno_requirements}" != "0" ]; then
		print_err_gui "${_error_requirements}"
		exit ${_errno_requirements}
	fi


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

			i=$((i + 1))

			# Percentage
			printf "%.0f\n" "$( div "$(mul "${i}" "100")" "${_total}" )"

			# Current file
			printf "# (%d/%d) %s\n" "${i}" "${_total}" "${f}"

			#
			# Execute action
			#
			_res="$( my_custom_action "${f}" )"
			_ret=$?


			#
			# Evaluate execution
			#
			if [ "${_ret}" != "0" ]; then
				#printf "%s\n" "FAILED"

				# Concat stderr messages
				_error="${_error}\n${_res}"

				# Concat failed files
				_err_files="${_err_files}\n${f}"

				# Increment fail count
				_err_cnt=$((_err_cnt + 1))
			#else
				#printf "%s\n" "OK"
			fi
		done
	) |
	zenity --progress \
	  --auto-kill \
	  --title="${MY_NAME}" \
	  --text="Scanning directories..." \
	  --percentage=0



	#
	# Evaluate final program success
	#
	if [ "${_err_cnt}" != "0" ]; then
		_err_files="$( remove_empty_lines "${_err_files}" )"
		print_err_gui "${_err_cnt} file(s) had errors:\n\n${_err_files}"
		exit $EXIT_ERR
	else
		print_ok_gui "${i} file(s) processed successfully."
		exit $EXIT_OK
	fi
}



#
# Main CLI function
#
main_cli() {
	# $ARG_SEPARATOR separated arguments
	_args="${*}"

	# Error messages/counter
	_err_files=""
	_err_cnt=0
	_error=""

	# Sys requirements checks
	_error_requirements="$(check_requirements)"
	_errno_requirements=$?
	if [ "${_errno_requirements}" != "0" ]; then
		print_err_cli "${_error_requirements}"
		exit ${_errno_requirements}
	fi


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
		i=$((i + 1))

		printf "(%d/%d) %s ... " "${i}" "${_total}" "${f}"

		#
		# Execute action
		#
		_res="$( my_custom_action "${f}" )"
		_ret=$?


		#
		# Evaluate execution
		#
		if [ "${_ret}" != "0" ]; then
			printf "%s\n" "FAILED"

			# Concat stderr messages
			_error="${_error}\n${_res}"

			# Concat failed files
			_err_files="${_err_files}\n${f}"

			# Increment fail count
			_err_cnt=$((_err_cnt + 1))
		else
			printf "%s\n" "OK"
		fi
	done

	#
	# Evaluate final program success
	#
	if [ "${_err_cnt}" != "0" ]; then
		_err_files="$( remove_empty_lines "${_err_files}" )"
		print_err_cli "${_err_cnt} file(s) had errors:\n\n${_err_files}"
		exit $EXIT_ERR
	else
		print_ok_cli "${i} file(s) processed successfully."
		exit $EXIT_OK
	fi
}





################################################################################
#
# MAIN ENTRY POINT
#
################################################################################



while [ $# -gt 0  ]; do
	case "${1}" in

		# ---- File Mode ----
		-f)
			# Shift `-f` away to get everything after it
			shift

			# Get arguments separated by a non-space value,
			# otherwise we cannot distinguish between arguments
			# with space inside (when passed to a function)
			ARGS=""
			for a in "$@"; do
				if [ "${ARGS}" = "" ]; then
					ARGS="${a}"
				else
					ARGS="${ARGS}${ARG_SEPARATOR}${a}"
				fi
			done

			if [ "${HAS_GUI}" = "1" ]; then
				# Make sure GUI requirements are met.
				ERROR="$( check_gui_requirements )"
				ERRNO=$?
				if [ "${ERRNO}" != "0" ]; then
					echo "${ERROR}"
					exit ${EXIT_ERR}
				fi

				main_gui "${ARGS}"
				exit $?
			else
				main_cli "${ARGS}"
				exit $?
			fi
			;;

		# ---- Compress Mode ----
		-c)
			# Shift `-f` away to get everything after it
			shift

			# Get arguments separated by " to prepare for compression.
			ARGS=""
			for a in "$@"; do
				if [ -f "${a}" ] || [ -d "${a}" ]; then
					if [ "${ARGS}" = "" ]; then
						ARGS="\"${a}\""
					else
						ARGS="${ARGS} \"${a}\""
					fi
				else
					# TODO: Use gui or cli error here
					echo "Invalid file: ${a}"
					exit ${EXIT_ERR}
				fi
			done

			#
			# TODO: if only one arg present, use its filename as target file
			#

			# Create archive
			OUTPUT_FILE="${HOME}/${MY_NAME}-$(date '+%Y-%m-%d__%H-%M-%S').tar.gz"
			COMMAND="tar -C ${HOME} -cf - ${ARGS} 2>/dev/null | gzip > ${OUTPUT_FILE}"
			eval "${COMMAND}"

			#
			# TODO: Add error checking here for above command
			#

			if [ "${HAS_GUI}" = "1" ]; then
				# Make sure GUI requirements are met.
				ERROR="$( check_gui_requirements )"
				ERRNO=$?
				if [ "${ERRNO}" != "0" ]; then
					echo "${ERROR}"
					exit ${EXIT_ERR}
				fi

				main_gui "${OUTPUT_FILE}"
				exit $?
			else
				main_cli "${OUTPUT_FILE}"
				exit $?
			fi
			;;




		# ---- Recursion ----
		-r)
			# Shift `-r` away to get everything after it
			shift

			# Make sure the parameter is an integer
			if ! isint "${1}"; then
				echo "Invalid integer argument for -r: '${1}'"
				echo "Type '${0} --help' for available options."
				exit ${EXIT_ERR}
			fi

			# Check if smaller than 0
			if [ "${1}" -lt "0" ]; then
				echo "Argument for -r must be greater than 0. You specified: '${1}'"
				echo "Type '${0} --help' for available options."
				exit ${EXIT_ERR}
			fi

			HAS_REC=1
			LVL_REC="${1}"
			;;


		# ---- Enable GUI mode ----
		-g)
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
			check_gui_requirements
			_ret=$?
			_cnt=$((_cnt + _ret))
			exit ${_ret}
			;;

		# ---- Invalid argument ----
		*)
			echo "Invalid argument: '${1}'"
			echo "Type '${0} --help' for available options."
			exit ${EXIT_ERR}
			;;
	esac
	shift
done


# Missing argument: -f
echo "Missing argument -f or -c"
echo "Type '${0} --help' for available options."
exit ${EXIT_ERR}


