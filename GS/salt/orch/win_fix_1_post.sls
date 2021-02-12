{% set event_data = salt['pillar.get']('event_data', {}) %}
{% set event_tag = salt['pillar.get']('event_tag', {}) %}

# Similar check done by Reactor (example)
{% if event_data['task'] == 'win_fix_1' and event_data['status'] == 'complete' %}

post_deployment_task:
  test.configurable_test_state:
    - name: doing post deployment task
    - result: True
    - changes: True
    - comment: |
        {{ event_tag }}
        Initiating restart
        
        {{ event_data }}
{% elif %}
post_deployment_task:
  test.configurable_test_state:
    - name: doing post deployment task
    - result: True
    - changes: True
    - comment: Nothing else to do
{% endif %}
