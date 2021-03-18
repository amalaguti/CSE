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
            on_not_found: True
            hive: HKLM
            key: SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe
            vname: Path
            value: 'C:\Program Files (x86)\Google\Chrome\Application'
        Amazon AMI Version:
            on_not_found: True
            hive: HKLM
            key: SOFTWARE\Amazon\MachineImage
            vname: AMIVersion
            value: '2019.06.12'
