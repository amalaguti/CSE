
{% set minion = salt['pillar.get']('minion', None) %}

install_IIS:
  salt.state:
    - tgt: '{{ minion }}'
    - sls:
      - do_something.apply_win_fix_full
        
reboot_minion_1:
  salt.function:
    - name: system.reboot
    - tgt: '{{ minion }}'
    - arg:
      - 1
    - require:
      - salt: install_IIS
     
wait_for_reboot_1:
  salt.wait_for_event:
    - name: salt/minion/*/start
    - id_list:
      - {{ minion }}
    - require:
      - salt: reboot_minion_1
    - timeout: 180

    
# ADD state to copy Tanium file
{#

#}

google_chrome_file_version_check:
  salt.state:
    - tgt: '{{ minion }}'
    - sls:
      - google_chrome.version_check_fileprop
    - require:
      - salt: wait_for_reboot_1
      
google_chrome_sw_version_check:
  salt.state:
    - tgt: '{{ minion }}'
    - sls:
      - google_chrome.version_check_sw
    - require:
      - salt: wait_for_reboot_1
      
google_chrome_reg_check:
  salt.state:
    - tgt: '{{ minion }}'
    - sls:
      - google_chrome.reg_check
    - require:
      - salt: wait_for_reboot_1

reboot_minion_2:
  salt.function:
    - name: system.reboot
    - tgt: '{{ minion }}'
    - arg:
      - 1
    - require:
      - salt: google_chrome_file_version_check  
      - salt: google_chrome_sw_version_check
      - salt: google_chrome_reg_check 
wait_for_reboot_2:
  salt.wait_for_event:
    - name: salt/minion/*/start
    - id_list:
      - {{ minion }}
    - require:
      - salt: reboot_minion_2
    - timeout: 180
  
  
  
post_deployment_task_2:
  test.configurable_test_state:
    - name: reboot completed
    - result: True
    - changes: False
    - comment: {{ minion }} rebooted
    - require:
      - salt: wait_for_reboot_2


 
