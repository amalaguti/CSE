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
{% else %}
post_deployment_task:
  test.configurable_test_state:
    - name: doing post deployment task
    - result: True
    - changes: True
    - comment: Nothing else to do
{% endif %}
