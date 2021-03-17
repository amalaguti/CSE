install_watchdog:
  pip.installed:
    - name: 'C:\watchdog\watchdog-2.0.2-py3-none-win_amd64.whl'
    - cwd: 'C:\salt\bin\scripts'
    - bin_env: 'C:\salt\bin\scripts\pip.exe'
    - upgrade: True
    - disable_version_check: True
    - no_index: True
    - log: 'C:\watchdog'
