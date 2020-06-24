{% set lot_of_data = salt['cmd.run_all']('cat /var/lib/pgsql/12/data/postgresql.conf') %}
{% for i in range(1) %}
lot_of_data-{{ i }}:
  test.configurable_test_state:
    - name: do {{ i }}
    - changes: False
    - result: True
    - comment: |
        {{ lot_of_data['stdout']|indent(8) }}
{% endfor %}
