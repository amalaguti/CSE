beacons:
  # THis overrides beacons:registry key from beacons_config
  # Manage this type of configs by roles (grains roles)
  registry:
    - interval: 7
    - entries:
        Chrome:
            on_not_found: True
            hive: HKLM
            key: SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe
            vname: Path
            value: 'C:\PF\Google\Chrome\Application'
        Amazon AMI Version:
            on_not_found: True
            hive: HKLM
            key: SOFTWARE\Amazon\MachineImage
            vname: AMIVersion
            value: '2019.06.XX'
