{# DEMONSTRATION STATE 
    This state is used to demonstrate that Jinja renders before yaml 
    Changing the registry during sleep time does not alter the result
    The output will show the initial value at Jinja rendering time
#}

{% set reg_info = salt['reg.read_value']('HKLM', 'SOFTWARE\Amazon\MachineImage', vname='Sample', use_32bit_registry=False).get('vdata', None) %}
show:
  test.configurable_test_state:
    - name: show
    - changes: False
    - result: True
    - comment: {{ reg_info }}
    
    
test.sleep:
  module.run:
    - length: 60


{% set reg_info = salt['reg.read_value']('HKLM', 'SOFTWARE\Amazon\MachineImage', vname='Sample', use_32bit_registry=False).get('vdata', None) %}
show_2:
  test.configurable_test_state:
    - name: show
    - changes: False
    - result: True
    - comment: {{ reg_info }}
