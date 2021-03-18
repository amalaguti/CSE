{% if grains['os'] == 'Windows' %}
{% set packages = salt['pkg.list_pkgs']() %}

show:
  test.configurable_test_state:
    - name: show
    - changes: false
    - result: True
    - comment: |
        {{ packages }}
        {% for name, version in packages.items() %}
        {{ name }} {{ version }}
        {% endfor %}
{#
grain_win_pkgs:
  grains.present:
    - name: win_pkgs
    - force: True
    - value:
        - {{ packages }}
#}
{% endif %}
