{% set event_data = salt['pillar.get']('event_data', {}) %}
{% set event_tag = salt['pillar.get']('event_tag', {}) %}

post_deployment_task:
  test.configurable_test_state:
    - name: doing post deployment task
    - result: True
    - changes: True
    - comment: |
        {{ event_tag }}
        Initiating restart
        
        {{ event_data }}
