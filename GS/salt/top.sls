base:
  'multimaster*':
    - highstates.base_config
    - highstates.sec_enforce_L1

  'config_data:env:MASTER*':
    - match: pillar
    - highstates.machine_info
  
  'win*':
    - watchdog.install
    - highstates.take_a_nap
    
dev:  
  'multimaster*':
    - highstates.development

  'config_data:env:QA*':
    - match: pillar
    - highstates.machine_info

