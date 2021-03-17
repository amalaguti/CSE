beacons:
  status:
    - time:
      - all
    - interval: 600
  service:
    - interval: 600
    - services:
        AWSLiteAgent:
          onchangeonly: True
          emitatstartup: False
  diskusage:
    -  interval: 3600
    - 'c:\\': 90%
  watchdog:
    - directories:
        'C:\watchdog':
          mask:
            - create
            - modify
            - delete
            - move
