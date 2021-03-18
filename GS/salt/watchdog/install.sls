#https://github.com/saltstack/salt/issues/58982
{% set watchdog_installed = False %}
{% set watchdog_ver = 'watchdog @ file:///C:/salt/bin/Scripts/watchdog-2.0.2-py3-none-win_amd64.whl' %}
{% set pip_freeze = salt['pip.freeze']() %}
{% if watchdog_ver in pip_freeze %}
{% set watchdog_installed = True %}
{% endif %}

{% if not watchdog_installed %}
salt_modules_grain_watchdog_false:
  grains.present:
    - name: salt_modules:watchdog
    - value:
      - installed: False
      - version: watchdog-2.0.2
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
    - reload_modules: True  # Not working - documented issue as of March 2021, https://github.com/saltstack/salt/issues/24925
    - cwd: 'C:\salt\bin\Scripts'
    - bin_env: 'C:\salt\bin\Scripts\pip.exe'
    - upgrade: True
    - unless:
      - 'C:\salt\bin\Scripts\pip.exe show watchdog'
      
restart_minion:
  module.run:
    - name: cmd.run_bg
    - cmd: 'c:\salt\salt-call.bat --local service.restart salt-minion'
{% endif %}


watchdog_loaded:
  test.configurable_test_state:
    - name: watchdog loaded
    - changes: False
    - result: True
    - comment: watchdog module is already loaded
    
salt_modules_grain_watchdog_true:
  grains.present:
    - name: salt_modules:watchdog
    - value:
      - installed: True
      - version: watchdog-2.0.2
