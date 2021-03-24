{% set software = salt['pkg.list_pkgs']() %}

{% if not 'Google Chrome' in software %}
install_chrome:
  cmd.run:
    - name: 'c:\ChromeSetup.exe /silent /install'
wait_time:
  module.run:
    - name: test.sleep
    - length: 45
{% endif %}
