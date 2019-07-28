#!/usr/bin/env bash

# filename: iqr.sh
# author: amughrabi@atypon.com

export version=0.0.1
export verbose=0

logo() {
cat <<'EOF'
  _____
  \_   \_ __ ___   __ _  __ _  ___
   / /\/ '_ ` _ \ / _` |/ _` |/ _ \
/\/ /_ | | | | | | (_| | (_| |  __/
\____/ |_| |_| |_|\__,_|\__, |\___|
                        |___/  Query Retrieval

EOF
}

help() {
logo
cat <<'EOF'
Usage:
iqr.sh [options] -e expression -l directory -o output.csv

    -h, -help,          --help                  Display help

    -v, -version,       --version               Display version

    -l, -location,      --location              Specify the root directory to start traversing the inode tree.

    -e, -expression,    --expression            Specify Attribute Percent Escapes (https://imagemagick.org/script/escape.php)
                                                to construct the expression for the output for each line; for example,
                                                '%[basename]:%[colorspace]\n' will log a line something like 'tjn.jpg:sRGB'

    -o, -output,        --output                Specify the output file; for example, output.csv.

    -V, -verbose,       --verbose               Run script in verbose mode. Will print out each step of execution.
EOF
}

version() {
    echo $version
}

promote() {
cat <<'EOF'

If you like it, please * this project on GitHub to make it known:
  https://github.com/amughrabi/iqr

EOF
}

# `getopt` brief decryption command:
# $@ is all command line parameters passed to the script.
# -o is for short options like -v
# -l is for long options with double dash like --version
# the comma separates different long options
# -a is for long options with single dash like -version
# : is for mark the arg need a value; for example, if we need to make the venison accept value, we can change the -o
#   value to hv:lVeo

options=$(getopt -l "help,version,location,verbose,expression,output" -o "hvl:Ve:o:" -a -- "$@")

# set --:
# If no arguments follow this option, then the positional parameters are unset. Otherwise, the positional parameters
# are set to the arguments, even if some of them begin with a ‘-’.
eval set -- "$options"

while true; do
    case $1 in
        -l|--location)
            loc="$2"
            shift
        ;;
        -e|--expression)
            expression="$2"
            shift
        ;;
        -o|--output)
            output="$2"
        ;;
        -h|--help)
            help
            exit 0
        ;;
        -v|--version)
            shift
            version
            exit 0
        ;;
        -V|--verbose)
            export verbose=1
            set -xv # Set xtrace and verbose mode.
        ;;
        *)
          shift
          break
        ;;
    esac
    shift
done

# Validation, empty.
if [[ ! -f "$loc" ]] && [[ ! -d "$loc" ]]; then
    echo "ERROR: $loc DOES NOT exists."
    exit 1
fi

if [[ -n "$output" ]] && [[  -d "$output" ]]; then
    echo "WARN $output DOES exist."
    exit 1
fi

if [[ -z $expression ]]; then
    echo "$expression"
    echo "ERROR: Missing expression value"
    exit 1
fi

# Ok! All parameters are exist.
logo
echo "Scan                    : $loc"
if [[ -f $output ]]; then
    echo "Output                  : $output"
    echo "To See the results; Use : tail -f $output"
fi

start=`date +%s`
echo "Started                 :" $(date +'%d-%b-%Y-%I:%M:%S-%z')
if [[ -f "$loc" ]]; then
    # if it is a file?
    info=$(identify -format $expression $loc)
   if [[ -f "$output" ]]; then
     echo ${info} >> "$output"
   else
     echo 'Output                  :'
     echo ${info}
   fi
else
#
# Navigate the root directory
# Core code
find $loc -name '*' -exec file {} \; | grep -o -P '^.+: .* image' | cut -d ':' -f 1 | while read -r file; do info=$(identify -format $expression $file[0] | head -1); if [[ -n "$info" ]]; then echo ${info} >> $output; fi; done
fi
end=`date +%s`
if [[ -f "$output" ]]; then
echo "Done                    : $output"
fi
echo "Ended                   :" $(date +'%d-%b-%Y-%I:%M:%S-%z')
echo "Took                    :" `expr $end - $start` seconds.
promote
echo "Bye!!"
