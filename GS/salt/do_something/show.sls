show_pillar:
  test.configurable_test_state:
    - name: show pillar
    - changes: False
    - result: True
    - comment: |
        {{ pillar }}
