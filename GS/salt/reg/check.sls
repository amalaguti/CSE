{% set reg_info = salt['reg.read_value']('HKLM', 'SOFTWARE\Amazon\MachineImage', vname='Sample', use_32bit_registry=False).get('vdata', None) %}

show:
  test.configurable_test_state:
    - name: show
    - changes: False
    - result: True
    - comment: {{ reg_info }}
    
    
test.sleep:
  module.run:
    - length: 10

show_2:
  test.configurable_test_state:
    - name: show
    - changes: False
    - result: True
    - comment: {{ reg_info }}
