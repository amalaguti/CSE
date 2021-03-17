copy_local_file:
  file.managed:
    - name: 'C:\salt\bin\Scripts\watchdog.whl'
    - source: salt://watchdog/files/watchdog-2.0.2-py3-none-win_amd64.whl
install_watchdog:
  pip.installed:
    #- name: 'watchdog-2.0.2-py3-none-win_amd64.whl'
    - name: 'watchdog.whl'
    - cwd: 'C:\salt\bin\Scripts'
    - bin_env: 'C:\salt\bin\Scripts\pip.exe'
    - upgrade: True
    - no_index: True
    #- find_links: 'C:\watchdog'
    #- log: 'C:\watchdog\watchdog.log'
