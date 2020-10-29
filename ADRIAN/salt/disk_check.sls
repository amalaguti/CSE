INTEGRATION



{% set disk_avail = salt['disk.usage']() %}
{% set disk_avail_root = disk_avail['/']['available'] %}
show:
  test.configurable_test_state:
    - name: show available disk space
    - changes: False
    - result: True
    - comment: |
        {{ disk_avail_root }} - 1kb blocks

{% if disk_avail_root | to_num > 10000000 %}
ok:
  test.succeed_without_changes
{% else %}
bail_out:
  test.fail_without_changes
{% endif %}
