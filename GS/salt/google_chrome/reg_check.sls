{#
Wait for registry key in place:
  loop.until_no_eval:
    - name: reg.key_exists
    - expected: True
    - compare_operator: eq
    - period: 5
    - timeout: 15
    - init_wait: 5
    - args:
      - HKLM
      - SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe
    - kwargs: {}
#}


Wait for registry value in place:
  loop.until_no_eval:
    - name: reg.read_value
    #- expected: 'vdata:"C:\Program Files (x86)\Google\Chrome\Application"'
    - expected: 'vdata|C:\Program Files (x86)'
    - compare_operator: data.subdict_match
    - period: 5
    - timeout: 15
    - init_wait: 3
    - args:
      - HKLM
      - SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe
    - kwargs:
        vname: Path2
    - delimiter: '|'
