{% if grains['os'] == 'Windows' %}
{% set packages = salt['pkg.list_pkgs']() %}

grain_win_pkgs:
  grains.present:
    - name: win_pkgs
    - force: True
    - value:
        - {{ packages }}
{% endif %}
