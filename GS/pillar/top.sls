base:
  '*':
    - beacons.beacons_config
   
  'multimaster*':
    - pillar_data.base_config
  'win*':
    - pillar_data.base_config
    - beacons.beacons_registry
    #- minion_config.config
