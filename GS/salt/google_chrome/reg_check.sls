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
