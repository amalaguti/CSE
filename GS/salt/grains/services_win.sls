{% if grains['os'] == 'Windows' %}
{% set services_all = salt['service.get_enabled']() %}

{% set services_info = {} %}
{% for service in services_all %}
{% set service_info = salt['service.info'](service) %}
{% do services_info.update({service: {
  'DisplayName': service_info['DisplayName'],
  'Status': service_info['Status'],
  'StartType': service_info['StartType'],
  'ServiceAccount': service_info['ServiceAccount'],
  'BinaryPath': service_info['BinaryPath']}}) %}
{% endfor %}

grain_win_pkgs:
  grains.present:
    - name: win_services
    - force: True
    - value:   
        {% for service, service_info in services_info.items() %}
        - {{ service }}: {{ service_info }}
        {% endfor %}
{% endif %}
