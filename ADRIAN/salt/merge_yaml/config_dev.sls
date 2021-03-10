{% import_yaml slspath ~ "/config_dev.yaml" as config_db %}

show:
  test.configurable_test_state:
    - name: show
    - changes: False
    - result: True
    - comment: |
        {{ config_db }}
