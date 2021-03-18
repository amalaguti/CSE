{% if grains['os'] == 'Windows' %}
{% if 'Google Chrome' in grains['win_pkgs'] %}
grain_role:
  grains.present:
    - name: role
    - force: True
    - value: 'Chromer'
{% endif %}
{% endif %}
