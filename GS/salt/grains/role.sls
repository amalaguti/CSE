{% if grains['os'] == 'Windows' %}
{% for pkg in grains['win_pkgs'] %}
show_{{ loop.counter }}:
  test.configurable_test_state:
    - name: show {{ loop.counter }}
    - changes: False
    - result: True
    - comment: |
        {{ pkg }}
#grain_role:
#  grains.present:
#    - name: role
#    - force: True
#    - value: 'Chromer'
{% endfor %}
{% endif %}
