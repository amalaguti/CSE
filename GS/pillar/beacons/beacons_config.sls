beacons:
  status:
    - time:
      - all
    - interval: 600
  service:
    - interval: 5
    - services:
        AWSLiteAgent:
          onchangeonly: False
          emitatstartup: True
         
        
