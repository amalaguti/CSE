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

