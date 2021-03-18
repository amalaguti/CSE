{% if grains['os'] == 'Windows' %}

# Look for packages (custom grain)
{% for pkg_info in grains['win_pkgs'] %}
  {% set outloop = loop.index %}
  
  {% for pkg, version in pkg_info.items() %}

    {% if pkg == 'Google Chrome' %}
# Add role for Chromer due Google Chrome found in pkgs
# Check if roles grain exist and is a list
    {% if 'roles' in grains and grains['roles']|is_list %}
    {% set roles = grains['roles'] %}
# Append to existing roles if it's not present
    {% if 'Chromer' not in roles %}
    {% do roles.append('Chromer') %}
grain_role:
  grains.present:
    - name: roles
    - force: True
    - value: {{ roles }}
    {% endif %}
    {% else %}
# If roles not in grains create roles grains
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
