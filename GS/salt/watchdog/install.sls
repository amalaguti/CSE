#https://github.com/saltstack/salt/issues/58982
{% set watchdog_installed = False %}
{% set watchdog_ver = 'watchdog @ file:///C:/salt/bin/Scripts/watchdog-2.0.2-py3-none-win_amd64.whl' %}
{% set pip_freeze = salt['pip.freeze']() %}
{% if watchdog_ver in pip_freeze %}
{% set watchdog_installed = True %}
{% endif %}

{% if not watchdog_installed %}
watchdog_not_loaded:
  test.configurable_test_state:
    - name: watchdog not loaded
    - changes: False
    - result: False
    - comment: watchdog not loaded, state will install it and restart salt-minion to load module
    
copy_local_file:
  file.managed:
    - name: 'C:\salt\bin\Scripts\watchdog-2.0.2-py3-none-win_amd64.whl'
    - source: salt://watchdog/files/watchdog-2.0.2-py3-none-win_amd64.whl
    
install_watchdog:
  pip.installed:
    - name: 'watchdog-2.0.2-py3-none-win_amd64.whl'
    - reload_modules: True  # Not working - documented issue as of March 2021
    - cwd: 'C:\salt\bin\Scripts'
    - bin_env: 'C:\salt\bin\Scripts\pip.exe'
    - upgrade: True
    - unless:
      - 'C:\salt\bin\Scripts\pip.exe show watchdog'
{% endif %}


restart_minion:
  module.run:
    - name: cmd.run_bg
    - cmd: 'salt-call --local service.restart salt-minion'

watchdog_loaded:
  test.configurable_test_state:
    - name: watchdog loaded
    - changes: False
    - result: True
    - comment: watchdog module is already loaded
