base:
  #'*':
   
  'multimaster*':
    - pillar_data.base_config
  'win*':
      #- minion_config.config
    - pillar_data.base_config
    - beacons.beacons_config
    
  # Custom grain created by grains.software_win 
  #'win_pkgs:Google Chrome:*':
  'roles:Chromer':
    - match: grain
    - beacons.beacons_registry

