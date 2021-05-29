{% set minion = salt['pillar.get']('minion') %}
show_minion:
  test.configurable_test_state:
    - name: show minion
    - changes: False
    - result: True
    - comment: {{ minion }}

retrieve_files:
  salt.runner:
    - name: vessel_ops_support.files_retrieval

engine_maintenance_check:
  salt.function:
    - name: vessel_engine.full_check
    - tgt: {{ minion }}
    - require:
      - salt: retrieve_files 


satellite_conn_check:
  salt.runner:
    - name: vessel_ops_support.satellite_conn_check
