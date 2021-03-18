#https://github.com/saltstack/salt/issues/58982
{% set is_watchdog = salt['pip.freeze']('cwd="C:\salt\bin\Scripts"', 'bin_env="C:\salt\bin\Scripts\pip.exe"') %}


copy_local_file:
  file.managed:
    - name: 'C:\salt\bin\Scripts\watchdog-2.0.2-py3-none-win_amd64.whl'
    - source: salt://watchdog/files/watchdog-2.0.2-py3-none-win_amd64.whl
install_watchdog:
  pip.installed:
    - name: 'watchdog-2.0.2-py3-none-win_amd64.whl'
    - reload_modules: True
    #- pkgs: 
    #  - 'watchdog-2.0.2-py3-none-win_amd64.whl'
    - cwd: 'C:\salt\bin\Scripts'
    - bin_env: 'C:\salt\bin\Scripts\pip.exe'
    - upgrade: True
    #- no_index: True
    #- find_links: 'C:\salt\bin\Scripts'
    #- log: 'C:\watchdog\watchdog.log'
    - unless:
      - 'C:\salt\bin\Scripts\pip.exe show watchdog'
      


do_reload_modules:
  test.configurable_test_state:
    - name: blah
    - changes: False
    - result: True
    - comment: |
        {{ is_watchdog }}
    - reload_modules: True
