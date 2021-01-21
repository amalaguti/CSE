show_pillar_data:
  test.configurable_test_state:
    - name: show pillar data
    - changes: false
    - result: True
    - comment: |
        {{ pillar['config_data'] }}
        {{ pillar['config_data']['users'] }}
        {{ pillar['config_data']['env'] }}
        {{ salt['pillar.get']('config_data', 'pillar not found') }}
        {{ salt['pillar.get']('config_data:users', 'pillar not found') }}
        {{ salt['pillar.get']('other', 'pillar not found') }}
        
