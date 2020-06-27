show_pillar:
  test.configurable_test_state:
    - name: show pillar
    - changes: false
    - result: true
    - comment: {{ pillar['a-secret'] }}


{% set decrypted_home = salt['gpg.decrypt'](filename='c:/my_secret1.txt.encrypted', gnupghome='C:/Users/Administrator/AppData/Roaming/gnupg/') %}


show_decrypt:
  test.configurable_test_state:
    - name: show decrypt
    - changes: false
    - result: true
    - comment: |
        Secrets:
        decrypted_home: {{ decrypted_home['comment'].decode('utf-8') }}
