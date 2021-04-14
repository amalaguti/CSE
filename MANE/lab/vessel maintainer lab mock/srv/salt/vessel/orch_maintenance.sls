{% set minion = salt['pillar.get']('minion') %}

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
