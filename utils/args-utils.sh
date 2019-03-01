#! /bin/bash
#
# args.sh
# Copyright (C) 2019 wanghuacheng <wanghuacheng@wanghuacheng-PC>
#
# Distributed under terms of the MIT license.
#
# declare -A args=()
# DESCRIPTION=`cat <<EOF
#      this script used for XXX
# EOF`
# args["all"]="a|along|no-args|b-default|a comment"
# args["bug"]="b|blong|args|b-default|b comment"
# args["debug"]="d|dlong|args|d-default|b comment"
# args["cover"]="c|cxx|args-opt|default|c comment"
#
# parse_args $@




SCRIPT=$0
help_args(){
    echo "usage: $SCRIPT [Options]"
    if [[ -n "$DESCRIPTION" ]];then
        echo "DESCRIPTION:"
        echo "$DESCRIPTION"
    fi
    for arg_name in ${!args[@]};do
        arg_options=${args[$arg_name]}
        short_name=`echo $arg_options|awk -F'|' '{print $1}'`
        long_name=`echo $arg_options|awk -F'|' '{print $2}'`
        arg_type=`echo $arg_options|awk -F'|' '{print $3}'`
        arg_default=`echo $arg_options|awk -F'|' '{print $4}'`
        arg_comment=`echo $arg_options|awk -F'|' '{print $5}'`
        if [[ "$arg_type" == "no-args" ]];then
            short_help="-${short_name}"
            long_help="--${long_name}"
        elif [[ "$arg_type" == "args" || "$arg_type" == "args-required" ]];then
            req_flag=""
            if [[ "$arg_type" == "args-required" ]];then
                req_flag=" required"
            fi
            short_help="-${short_name}"
            long_help="--${long_name}=val ${req_flag}"
        elif [[ "$arg_type" == "args-opt" ]];then
            short_help="-${short_name}"
            long_help="--${long_name}[=val]"
        else
            echo "${arg_type} not support"
            exit -1
        fi

        printf "%10s|%-20s default:%-15s %s\n" "$short_help" "$long_help" "$arg_default" "$arg_comment"
    done
}

parse_args(){
    local parse_o=""
    local parse_l=""
    local app_args="$@"
    local req_args=()
    case_scripts="while true ; do "
    case_scripts="$case_scripts case \"\$1\" in "
    for arg_name in ${!args[@]};do
        arg_options=${args[$arg_name]}
        short_name=`echo $arg_options|awk -F'|' '{print $1}'`
        long_name=`echo $arg_options|awk -F'|' '{print $2}'`
        arg_type=`echo $arg_options|awk -F'|' '{print $3}'`
        arg_default=`echo $arg_options|awk -F'|' '{print $4}'`
        arg_comment=`echo $arg_options|awk -F'|' '{print $5}'`
        case_scripts="$case_scripts -${short_name}|--${long_name}) "
        eval "${arg_name}=${arg_default}"

        if [[ "$arg_type" == "no-args" ]];then
            case_scripts="$case_scripts $arg_name=1; shift  ;;"
            short_name="${short_name}"
            long_name="${long_name}"
        elif [[ "$arg_type" == "args" || "$arg_type" == "args-required" ]];then
            if [[ "$arg_type" == "args-required" ]];then
                req_args+=($arg_name)
            fi
            case_scripts="$case_scripts $arg_name=\"\$2\"; shift 2 ;;"
            short_name="${short_name}:"
            long_name="${long_name}:"
        elif [[ "$arg_type" == "args-opt" ]];then
            case_scripts="$case_scripts $arg_name=\"\$2\"; shift 2 ;;"
            short_name="${short_name}::"
            long_name="${long_name}::"
        else
            echo "${arg_type} not support"
            exit -1
        fi
        parse_o="${parse_o}${short_name}"
        if [[ -n "$parse_l" ]];then
            parse_l="${parse_l},${long_name}"
        else
            parse_l="${parse_l}${long_name}"
        fi

    done
    case_scripts="$case_scripts -h|--help) help_args; exit 0;; "
    case_scripts="$case_scripts --) shift; break;;"
    case_scripts="$case_scripts *) echo \"Internal error!\$1\n\" ; help_args ; exit 1 ;;"
    case_scripts="$case_scripts esac; done"


    parse_o="${parse_o}h"
    if [[ -n "$parse_l" ]];then
        parse_l="${parse_l},help"
    else
        parse_l="help"
    fi
    TEMP=`getopt -o ${parse_o} -l ${parse_l} -n ${SCRIPT} -- $app_args`
    if [ $? != 0 ] ; then echo "Terminating..."; help_args; >&2 ; exit 1 ; fi
    eval set -- "$TEMP"
    eval $case_scripts

    for arg_name in ${req_args};do
        arg_val=$(eval "echo \$$arg_name")
        if [[ -z $arg_val ]];then
            echo "$arg_name is requried"
            help_args
            exit
        fi
    done

    for arg_name in ${!args[@]};do
        eval "echo $arg_name:\$$arg_name"
    done
}


