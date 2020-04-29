{% set random_start = range(1, 5) | random %}
random_sleep:
  module.run:
    - name: test.sleep
    - length: {{ random_start }}

pause:
  salt.runner:
    - name: test.sleep
    - s_time: {{ random_start }}

orchestrate_state-success:
  test.configurable_test_state:
    - name: Data success on Orchestration Call
    - changes: False
    - result: True
    - comment: |
        Finished ok
        event_data: {{ random_start }}
        sleep: {{ random_start }}
