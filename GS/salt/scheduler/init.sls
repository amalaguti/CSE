sched_highstate:
  schedule.present:
    - function: state.apply
#    - job_args:
#    - job_kwargs:
    - splay:
        start: 3
        end: 10
    - seconds: 120
