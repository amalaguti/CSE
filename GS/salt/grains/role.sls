{% if grains['os'] == 'Windows' %}

{% for pkg_info in grains['win_pkgs'] %}
  {% set outloop = loop.index %}
  
  {% for pkg, version in pkg_info.items() %}

    {% if pkg == 'Google Chrome' %}
    {% if 'roles' in grains and grains['roles']|is_list %}
    {% set roles = grains['roles'] %}
    {% if 'Chromer' not in roles %}
    {% do roles.append('Chromer') %}
grain_role:
  grains.present:
    - name: roles
    - force: True
    - value: {{ roles }}
    {% endif %}
    {% else %}
grain_role:
  grains.present:
    - name: roles
    - force: True
    - value: 
      - 'Chromer' 
    {% endif %}  
    {% endif %}
 
 {% endfor %}
{% endfor %}
{% endif %}
