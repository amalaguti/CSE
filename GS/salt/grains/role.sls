{% if grains['os'] == 'Windows' %}
{% if 'Google Chrome' in grains['win_pkgs'] %}
grain_role:
  grains.present:
    - name: role
    - force: True
    - value: 'Chromer'
{% else %}
show:
  test.configurable_test_state:
    - name: show
    - changes: False
    - result: True
    - comment: |
        {{ grains['win_pkgs'].keys() }}
{% endif %}
{% endif %}
