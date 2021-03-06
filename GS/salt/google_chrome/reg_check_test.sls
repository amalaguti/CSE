Wait for registry value in place:
  loop.until_no_eval:
    - name: reg.read_vdata
    - expected: 'C:\Program Files (x86)\Google\Chrome\Application'
    - compare_operator: eq
    - period: 5
    - timeout: 15
    - init_wait: 3
    - args:
      - HKLM
      - SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe
    - kwargs:
        vname: Path
