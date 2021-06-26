# keep track of minion status beacons in its register
statreg:
  status.reg
  

# deletes the key from the master when the minion has been gone for 60 seconds
keydel:
  key.timeout:
    - delete: 300 #10 days
    - start_time: 04
    - end_time: 23
    - onchanges:
      - status: statreg
      
      
#myreg:
#  file.save

