beacons:
  status:
    - time:
      - all
    - interval: 600
  service:
    - interval: 5
    - services:
        AWSLiteAgent:
          onchangeonly: True
          emitatstartup: True
