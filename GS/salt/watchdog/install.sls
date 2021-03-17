install_watchdog:
  pip.installed:
    - name: 'watchdog-2.0.2-py3-none-win_amd64.whl'
    - cwd: 'C:\salt\bin\scripts'
    - bin_env: 'C:\salt\bin\scripts\pip.exe'
    - upgrade: True
    - no_index: True
    #- find_links: 'C:\watchdog'
    #- log: 'C:\watchdog\watchdog.log'
