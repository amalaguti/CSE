beacons:
  # THis overrides beacons:registry key, cleaning what is set in beacons_config
  # Manage this type of configs by roles (grains roles)
  registry:
    - interval: 5
    - entries:
        Chrome:
            on_not_found: True
            hive: HKLM
            key: SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\chrome.exeX
            vname: Path
            value: 'xC:\Program Files\Google\Chrome\Application'
        Amazon AMI Version:
            on_not_found: True
            hive: HKLM
            key: SOFTWARE\Amazon\MachineImage
            vname: AMIVersion
            value: '2019.06.11'
