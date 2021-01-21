machine_info:
  test.configurable_test_state:
    - name: show machine info
    - changes: False
    - result: True
    - comment: |
        minion id: {{ grains['id'] }}
        platform: {{ grains['osfinger'] }}
        salt version: {{ grains['saltversion'] }}
        {%- if grains['kernel'] == 'Linux' %}
        {{ salt['cmd.run']('date') }}
        {%- endif %}
        {% if pillar['config_data']['env'] == 'QA dev' %}
        DEV Environment
        {% else %}
        PROD Environment
        {% endif %}
