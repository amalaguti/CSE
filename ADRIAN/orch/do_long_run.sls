do_something:
  salt.function:
    - name: cmd.run
    - tgt: 'myminion'
    - arg:
      - sleep 3
{#
do_something_else:
  salt.state:
    - tgt: 'saltmaster'
    - sls: do_task_B


do_last_thing:
  salt.function:
    - name: cmd.run
    - tgt: 'saltmaster'
    - arg:
      - sleep 3
#}
