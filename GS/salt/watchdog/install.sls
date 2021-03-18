#https://github.com/saltstack/salt/issues/58982
{% set watchdog_installed = False %}
{% set watchdog_ver = 'watchdog @ file:///C:/salt/bin/Scripts/watchdog-2.0.2-py3-none-win_amd64.whl' %}
{% set pip_freeze = salt['pip.freeze']() %}
{% if watchdog_ver in pip_freeze %}
{% set watchdog_installed = True %}
{% endif %}

#'cwd="C:\\salt\\bin\\Scripts"', 'bin_env="C:\\salt\\bin\\Scripts\\pip.exe"'

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
#restart_minion:
#  module.run:
#    - cmd.run_bg:
#      - cmd: 'salt-call --local service.restart salt-minion'



do_reload_modules:
  test.configurable_test_state:
    - name: blah
    - changes: False
    - result: True
    - comment: |
        {{ pip_freeze }}
        {{ watchdog_installed }}
