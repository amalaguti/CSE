{% if grains['os'] == 'Windows' %}

{% for pkg_info in grains['win_pkgs'] %}
  {% set outloop = loop.index %}
  
  {% for pkg, version in pkg_info.items() %}
{#
show_{{outloop}}{{ loop.index }}:
  test.configurable_test_state:
    - name: show {{outloop}}{{ loop.index }}
    - changes: False
    - result: True
    - comment: |
        {{ pkg }} {{ version }}
#}

    {% if pkg == 'Google Chrome' %}
    {% if 'roles' in grains and grains['roles']|is_list %}
grain_role:
  grains.present:
    - name: roles
    - force: True
    - value: 
      - 'Chromer'
    {% endf %}  
    {% endif %}
 
 {% endfor %}
{% endfor %}
{% endif %}
