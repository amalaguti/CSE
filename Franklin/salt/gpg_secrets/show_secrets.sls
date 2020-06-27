show_pillar:
  test.configurable_test_state:
    - name: show pillar
    - changes: false
    - result: true
    - comment: {{ pillar['a-secret'] }}


{% set decrypted_user = salt['gpg.decrypt'](filename='/srv/salt/gpg_secrets/my_secret1.txt.encrypted', user='salt') %}
{% set decrypted_home = salt['gpg.decrypt'](filename='/srv/salt/gpg_secrets/my_secret1.txt.encrypted', gnupghome='/etc/salt/gpgkeys/') %}


show_decrypt:
  test.configurable_test_state:
    - name: show decrypt
    - changes: false
    - result: true
    - comment: |
        Secrets:
        decrypted_user: {{ decrypted_user['comment'].decode('utf-8') }}
        decrypted_home: {{ decrypted_home['comment'].decode('utf-8') }}
