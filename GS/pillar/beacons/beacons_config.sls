beacons:
  status:
    - time:
      - all
    - interval: 600
  service:
    - interval: 60
    - services:
        AWSLiteAgent:
          onchangeonly: True
          emitatstartup: False


