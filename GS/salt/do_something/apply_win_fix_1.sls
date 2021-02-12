winmgmt/do_restart:
  event.send:
    - data:
        status: "win_fix_1 complete"
        master_ip: {{ salt['config.get']('master_ip') }}
        task: "win_fix_1"
