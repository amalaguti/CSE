base:
  'multimaster*':
    - highstates.base_config
    - highstates.sec_enforce_L1

dev:  
  'multimaster*':
    #- highstates.base_config
    #- highstates.sec_enforce_L1
    - highstates.development
