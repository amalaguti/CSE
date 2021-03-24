{% set chrome_versions = ['88.0.4324.182', '89.0.4389.90'] %}
{% set chrome_sw_ver_1 = salt['pkg.list_pkgs']().get('Google Chrome', None) %}

{% if not chrome_sw_ver_1 in chrome_versions %}
install_chrome:
  cmd.run:
    - name: 'c:\ChromeSetup.exe /silent /install'
wait_time:
  module.run:
    - name: test.sleep
    - length: 45
{% endif %}


{% if chrome_sw_ver_1 in chrome_versions %}
chrome_version_sw_1:
  test.succeed_without_changes
{% else %}
chrome_version_sw_1:
  test.fail_without_changes
{% endif %}


{% set chrome_sw_ver_2 = salt['pkg.list_pkgs']().get('Google Chrome', None) %}

{% if chrome_sw_ver_2 in chrome_versions %}
chrome_version_sw_2:
  test.succeed_without_changes
{% else %}
chrome_version_sw_2:
  test.fail_without_changes
{% endif %}
