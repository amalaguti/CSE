IIS-WebServerRole:
  win_servermanager.installed:
    - name: Web-Server
    - recurse: True
    - retry:
        attempts: 3
        interval: 30
