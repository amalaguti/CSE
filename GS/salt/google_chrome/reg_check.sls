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



# NOTE: this module is not ready to pass a different delimiter
# required by data.subdict_match to match this value
# This is required due 'C:\Program...', ':' is interpreted as delimiter.
# To update the module, pass delimiter argument to be used by data module
# Line 214  cmp_res = comparator(res, expected, delimiter='|')
# I have created issue https://github.com/saltstack/salt/issues/59701
{#
Wait for registry value in place:
  loop.until_no_eval:
    - name: reg.read_value
    - expected: 'vdata:C:\Program Files (x86)\Google\Chrome\Application'
    - compare_operator: data.subdict_match
    - period: 5
    - timeout: 15
    - init_wait: 3
    - args:
      - HKLM
      - SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe
    - kwargs:
        vname: Path
#}
# WORKAROUND: Created custom module to get specific value and be able to compare 
# the string using the 'eq' operator
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
