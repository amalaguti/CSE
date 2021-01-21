machine_info:
  test.configurable_test_state:
    - name: show machine info
    - changes: False
    - result: True
    - comment: |
        {{ grains['id'] }} - {{ grains['osfinger'] }} - {{ grains['saltversion'] }}
        {%- if grains['kernel'] == 'Linux' %}
        {{ salt['cmd.run']('date') }}
        {%- endif %}
