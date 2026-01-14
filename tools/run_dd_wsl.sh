#!/usr/bin/env bash
set -euo pipefail
# Headless Dream Daemon runner for WSL.
# Uses BYOND env setup at /home/dev/byond/bin/byondsetup.
# Preferred path for running the server/tests from Linux (see docs/wsl_dreamdaemon.md).

source /home/dev/byond/bin/byondsetup
# Ensure locally installed aux libraries (rust_g, dreamluau) are discoverable.
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/dev/.byond/bin"
cd "/mnt/c/Dev/Cloned repos/SPLURT/S.P.L.U.R.T-tg"

# CLI: optional --tests to run unit tests instead of a normal server.
RUN_TESTS=0
if [[ "${1-}" == "--tests" ]]; then
	RUN_TESTS=1
fi

PORT=${PORT:-7777}
if [[ $RUN_TESTS -eq 1 ]]; then
	LOG_PATH="data/dd-wsl-tests.log"
	PID_PATH="data/dd-wsl-tests.pid"
else
	LOG_PATH="data/dd-wsl.log"
	PID_PATH="data/dd-wsl.pid"
fi

if [[ $RUN_TESTS -eq 1 ]]; then
	echo "Running Dream Daemon unit tests on port $PORT (log: $LOG_PATH)"
	dreamdaemon tgstation.dmb "$PORT" -trusted -invisible -tests -log "$LOG_PATH" -pidfile "$PID_PATH"
else
	echo "Starting Dream Daemon headless on port $PORT (log: $LOG_PATH, pidfile: $PID_PATH)"
	dreamdaemon tgstation.dmb "$PORT" -trusted -invisible -log "$LOG_PATH" -pidfile "$PID_PATH" &
fi
