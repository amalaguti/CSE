base:
  #'*':
   
  'multimaster*':
    - pillar_data.base_config
  'win*':
      #- minion_config.config
    - pillar_data.base_config
    - beacons.beacons_config
    
  # Custom grain created by 
  'win_pkgs:Google Chrome:*':
    - match: grain
    - beacons.beacons_registry

