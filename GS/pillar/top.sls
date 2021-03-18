base:
  #'*':
   
  'multimaster*':
    - pillar_data.base_config
  'win*':
      #- minion_config.config
    - pillar_data.base_config
    - beacons.beacons_config
    - beacons.beacons_registry

