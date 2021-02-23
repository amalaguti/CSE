winmgmt/do_restart:
  event.send:
    - data:
        task: "win_fix_1"
        status: "complete"
        minion_master_ip: {{ salt['config.get']('master_ip') }}

