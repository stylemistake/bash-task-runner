## logger.sh
## Logging facilities
## --------------------------------------------------------
##  Copyright (c) 2019 Aleksej Komarov
##  SPDX-License-Identifier: LGPL-3.0-or-later
## --------------------------------------------------------

logger_verbosity=3
# logger_verbosity_levels=(error action warning info debug)

## Allow enabling of debug logs using this environment variable
declare DEBUG
if [[ -n ${DEBUG} ]]; then
  logger_verbosity=4
fi

## Logs a message
## You can use environment variable LOGLEVEL to set desired level of
## verbosity
## Usage: ${0} [-adeiw] [<message> ...]
logger-log() {
  if list-in "${1}" -e --error; then
    shift 1
    if [[ ${logger_verbosity} -ge 0 ]]; then
      colorize -b -c light-red "=> " -c white "${*}" >&2
    fi
    return
  fi
  if list-in "${1}" -a --action; then
    shift 1
    if [[ ${logger_verbosity} -ge 1 ]]; then
      colorize -b -c light-green "=> " -c white "${*}" >&2
    fi
    return
  fi
  if list-in "${1}" -w --warning; then
    shift 1
    if [[ ${logger_verbosity} -ge 2 ]]; then
      colorize -b -c light-yellow "=> " -c white "${*}" >&2
    fi
    return
  fi
  if list-in "${1}" -i --info; then
    shift 1
    if [[ ${logger_verbosity} -ge 3 ]]; then
      colorize -b -c light-blue ":: " -c white "${*}" >&2
    fi
    return
  fi
  if list-in "${1}" -d --debug; then
    shift 1
    if [[ ${logger_verbosity} -ge 4 ]]; then
      colorize -c light-grey "${*}" >&2
    fi
    return
  fi
  if [[ ${logger_verbosity} -ge 3 ]]; then
    echo "${*}" >&2
  fi
}

## Prints and executes the passed command
## Usage: ${0} [<command> <arg> ...]
## Note: Do not use this on bash built-ins which are affected by function
## scope, e.g. 'source'.
logger-exec() {
  colorize -b -c light-green "=> " +b -c grey "${*}" >&2
  "${@}"
}