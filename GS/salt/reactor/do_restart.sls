{% if data['data']['task'] == 'win_fix_1' and data['data']['status'] == 'complete' %}
restart_wait_minion:
  runner.state.orchestrate:
    - args:
      - mods: orch.{{ data['data']['task'] }}_post
      - pillar:
          event_data: {{ data['data'] | tojson }}
          event_tag: {{ tag | tojson }}
          minion: {{ data['id'] }}
{% endif %}
