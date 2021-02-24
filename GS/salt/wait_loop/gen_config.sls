{% set TEMP = salt['environ.get']('TEMP', 'c:\\') %}

show:
  test.configurable_test_state:
    - comment: |
        {{ TEMP }}

copy_gen_config:
  file.managed:
    - name: {{ TEMP }}\gen_config.bat
    - source: salt://win_cases/gen_config.bat
    # this bat sleeps a few seconds then creates a %TEMPT%\test.txt file

run_gen_config:
  cmd.run:
    - name: {{ TEMP }}\gen_config.bat
    - bg: True
    - timeout: 300
    - creates: {{ TEMP }}\test.txt

Wait for service to be healthy:
  loop.until_no_eval:
    - name: file.file_exists
    - expected: True
    - compare_operator: eq
    - period: 10
    - timeout: 300
    - init_wait: 20
    - args:
      - {{ TEMP }}\test.txt
