{% if grains['os'] == 'Windows' %}
{% set services_all = salt['service.get_enabled']() %}

{% set services_info = {} %}
{% for service in services_all %}
{% set service_info = salt['service.info'](service) %}
{% do services_info.update({service: {
  'DisplayName': service_info['DisplayName'],
  'Status': service_info['Status'],
  'BinaryPath': service_info['BinaryPath']}}) %}
{% endfor %}

show:
 test.configurable_test_state:
   - name: show
   - changes: False
   - result: True
   - comment: |
       {{ services_info }}
{#
grain_win_pkgs:
  grains.present:
    - name: win_pkgs
    - force: True
    - value:   
        {% for name, version in packages.items() %}
        - {{ name }}: {{ version }}
        {% endfor %}
#}
{% endif %}
