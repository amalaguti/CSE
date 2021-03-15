Wait for registry value in place:
  loop.until_no_eval:
    - name: reg.read_value
    - expected: "vdata:\Program Files (x86)\Google\Chrome\Application"
    - compare_operator: data.subdict_match
    - period: 3
    - timeout: 3
    - init_wait: 1
    - args:
      - HKLM
      - SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe
    - kwargs:
        vname: Path
