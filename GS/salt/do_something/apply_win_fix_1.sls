winmgmt/do_restart:
  event.send:
    - data:
        task: "win_fix_1"
        status: "complete"
        master_ip: {{ salt['config.get']('master_ip') }}

