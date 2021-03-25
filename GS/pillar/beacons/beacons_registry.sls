beacons:
  # THis overrides beacons:registry key, cleaning what is set in beacons_config
  # Manage this type of configs by roles (grains roles)
  registry:
    - interval: 10
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
            value: '2019.06.XXXX'
