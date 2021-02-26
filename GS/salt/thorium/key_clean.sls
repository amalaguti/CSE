# keep track of minion status beacons in its register
statreg:
  status.reg
  

# deletes the key from the master when the minion has been gone for 60 seconds
keydel:
  key.timeout:
    - delete: 86400
    - start_time: 04
    - end_time: 08
    - onchanges:
      - status: statreg
      
      
#myreg:
#  file.save

