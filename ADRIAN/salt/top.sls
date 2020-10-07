base:
  '*':
    - mock-pillar-grains-beacons.set_grain_hpmgr   # set grain for HPManager node
    - mock-pillar-grains-beacons.pip               # install pip (python2 easy_install)
    - mock-pillar-grains-beacons.pyinotify         # pip instal pyinotify
