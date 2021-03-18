{% if grains['os'] == 'Windows' %}

{% for pkg in grains['win_pkgs'] %}
{% set outloop = loop.index %}
 {% for key, value in pkg.items() %}
show_{{outloop}}{{ loop.index }}:
  test.configurable_test_state:
    - name: show {{outloop}}{{ loop.index }}
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
