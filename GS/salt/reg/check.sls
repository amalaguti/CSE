
show:
  test.configurable_test_state:
    - name: show
    - changes: False
    - result: True
    - comment: {{ reg_info }}

{% set reg_info = salt['reg.read_value']('HKLM', 'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe', vname='Path', use_32bit_registry=False).get('vdata', None) %}
