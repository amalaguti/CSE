{% if grains['os'] == 'Windows' %}
{% for pkg in grains['win_pkgs'] %}
 {% for key, value in pkg.items() %}
show_{{ loop.index }}:
  test.configurable_test_state:
    - name: show {{ loop.index }}
    - changes: False
    - result: True
    - comment: |
        {{ key }} {{ value }}
#grain_role:
#  grains.present:
#    - name: role
#    - force: True
#    - value: 'Chromer'
{% endfor %}
{% endfor %}
{% endif %}
