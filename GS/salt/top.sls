# base is ignore in dev environment
# minions with saltenv: dev will get empty highstate
base:  
  'multimaster*':
    - highstates.dev_1


dev:  
  'multimaster*':
    - highstates.dev_1

  'config_data:env:QA*':
    - match: pillar
    - highstates.machine_info
