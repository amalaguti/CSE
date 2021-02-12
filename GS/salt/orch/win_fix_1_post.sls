{% set event_data = salt['pillar.get']('event_data', {}) %}
{% set event_tag = salt['pillar.get']('event_tag', {}) %}
{% set minion = salt['pillar.get']('minion', None) %}

# Similar check done by Reactor (example)
{% if event_data['task'] == 'win_fix_1' and event_data['status'] == 'complete' and minion %}
post_deployment_task:
  test.configurable_test_state:
    - name: doing post deployment task
    - result: True
    - changes: True
    - comment: |
        {{ event_tag }}
        Initiating restart of minion {{ minion }}
        
        {{ event_data }}
        
reboot_minion:
  salt.function:
    - name: system.reboot
    - tgt: '{{ minion }}'
    - arg:
      - 1

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
        
        
{% else %}
post_deployment_task:
  test.configurable_test_state:
    - name: doing post deployment task
    - result: True
    - changes: False
    - comment: Nothing else to do
{% endif %}
