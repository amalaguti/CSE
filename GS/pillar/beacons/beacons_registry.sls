beacons:
  registry:
    - interval: 5
    - entries:
        Chrome2:
            on_not_found: True
            hive: HKLM
            key: SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe
            vname: Path
            value: CAMBIAR ESTO URGENTE
        Amazon AMI Version2:
            on_not_found: True
            hive: HKLM
            key: SOFTWARE\Amazon\MachineImage
            vname: AMIVersion
            value: CAMBIAR ESTO URGENTE
