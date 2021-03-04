#88.0.4324.190
{% set chrome_versions = ['88.0.4324.182'] %}
{% set chrome_sw_ver = salt['pkg.list_pkgs']().get('Google Chrome', None) %}


{% if chrome_sw_ver in chrome_versions %}
chrome_version:
  test.succeed_without_changes
{% else %}
chrome_version:
  test.fail_without_changes
{% endif %}
