{% set TEMP = salt['environ.get']('TEMP', 'c:\\') %}

show:
  test.configurable_test_state:
    - comment: |
        {{ TEMP }}

{#
copy_gen_config:
  file.managed:
    - name: {{ TEMP }}\gen_config.bat
    - source: salt://{{ slspath }}/gen_config.bat
    # this bat sleeps a few seconds then creates a %TEMPT%\test.txt file

run_gen_config:
  cmd.run:
    - name: {{ TEMP }}\gen_config.bat
    - bg: True
    - timeout: 180
    - creates: {{ TEMP }}\test.txt

Wait for service to be healthy:
  loop.until_no_eval:
    - name: file.file_exists
    - expected: True
    - compare_operator: eq
    - period: 10
    - timeout: 120
    - init_wait: 10
    - args:
      - {{ TEMP }}\test.txt
    - onchanges:
      - cmd: run_gen_config
#}
Wait for service to be healthy:
  loop.until_no_eval:
    - name: reg.read_value
    - expected: 'vdata:2019.06.11'
    - compare_operator: data.subdict_match
    - period: 3
    - timeout: 20
    - init_wait: 3
    - args:
      - HKLM
      - SOFTWARE\Amazon\MachineImage
    - kwargs:
        vname: AMIVersion
    #- onchanges:
    #  - cmd: run_gen_config
