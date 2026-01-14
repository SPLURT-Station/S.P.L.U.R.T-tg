# WSL Dream Daemon / Tests

Preferred CI/dev path: use the WSL BYOND install and run Dream Daemon headless from Linux for builds/tests. Avoid Windows BYOND unless explicitly requested.

## Prereqs

- WSL Ubuntu with BYOND installed and initialized via `/home/dev/byond/bin/byondsetup` (already set up).
- Repo mounted at `/mnt/c/Dev/Cloned repos/SPLURT/S.P.L.U.R.T-tg` (default). Update paths if your mount differs.

## Script

- Entry point: `tools/run_dd_wsl.sh`
- Default port: `7777` (override with `PORT=1234`).
- Logs: `data/dd-wsl.log` (or `data/dd-wsl-tests.log` when running tests).
- PID files: `data/dd-wsl.pid` (or `data/dd-wsl-tests.pid`).

## Usage

- Start server (headless, trusted, invisible):
  - `wsl bash tools/run_dd_wsl.sh`
- Run unit tests headlessly:
  - `wsl PORT=7778 bash tools/run_dd_wsl.sh --tests`

## AI/automation guidance

- When asked to "run tests linux" or "build server linux", prefer `tools/run_dd_wsl.sh --tests` under WSL.
- When asked to "start server" or "build server linux", prefer `tools/run_dd_wsl.sh` under WSL.
- Do not use Windows Dream Daemon unless specifically requested.
- Keep the default port unless the user provides `PORT=...`.
