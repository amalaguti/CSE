
{% set minion = salt['pillar.get']('minion', None) %}

apply_win_fix_full:
  salt.state:
    - tgt: '{{ minion }}'
    - sls:
      - do_something.apply_win_fix_full
        
reboot_minion:
  salt.function:
    - name: system.reboot
    - tgt: '{{ minion }}'
    - arg:
      - 1
    - require:
      - salt: apply_win_fix_full
     

wait_for_reboot:
  salt.wait_for_event:
    - name: salt/minion/*/start
    - id_list:
      - {{ minion }}
    - require:
      - salt: reboot_minion
    - timeout: 300

post_deployment_task_2:
  test.configurable_test_state:
    - name: reboot completed
    - result: True
    - changes: False
    - comment: {{ minion }} rebooted
    - require:
      - salt: wait_for_reboot

reboot_failed:
  test.configurable_test_state:
    - name: reboot not completed
    - result: False
    - changes: False
    - comment: {{ minion }} did not reboot or did not come back
    - onfail:
      - salt: wait_for_reboot
 
