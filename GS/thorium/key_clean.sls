# keep track of minion status beacons in its register
statreg:
  status.reg
  

# deletes the key from the master when the minion has been gone for 60 seconds
keydel:
  key.timeout:
    - delete: 60
    - start_time: 23
    - end_time: 1
    - require:
      - status: statreg
      
myreg:
  file.save
      
