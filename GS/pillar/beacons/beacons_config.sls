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
    -  interval: 20
    - 'c:\\': 10%
  watchdog:
    #- interval: 20
    - directories:
        'C:\info':
          mask:
            - create
            - modify
            - delete
            - move
        'C:\watchdog':
          mask:
            - create
            - modify
            - delete
            - move
           
  registry:
    - interval: 5
    - entries:
        Chrome:
            hive: HKLM
            key: SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe
            vname: Path2
        Amazon AMI Version:
            hive: HKLM
            key: SOFTWARE\Amazon\MachineImage
            vname: AMIVersion
