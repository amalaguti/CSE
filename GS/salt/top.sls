# base is ignore in dev environment
# minions with saltenv: dev will get empty highstate
base:  
  'multimaster*':
    #- highstates.base_config
    #- highstates.sec_enforce_L1
    - highstates.dev_1


dev:  
  'multimaster*':
    #- highstates.base_config
    #- highstates.sec_enforce_L1
    - highstates.dev_1
