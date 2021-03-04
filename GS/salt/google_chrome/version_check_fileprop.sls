{% set chrome_versions = ['88.0.4324.182', '88.0.4324.19XXX'] %}
{% set chrome_fileprop_ver = salt['file.get_properties']('C:\Program Files (x86)\Google\Chrome\Application\chrome.exe').get('FileVersion', None) %}


{% if chrome_fileprop_ver in chrome_versions %}
chrome_version_fileprop:
  test.succeed_without_changes
{% else %}
chrome_version_fileprop:
  test.fail_without_changes
{% endif %}
