import logging
log = logging.getLogger(__name__)

def show_data():
    log.info(">>>>>>>>> {0}".format(__name__))
    return True

def get_minion_config():
    """
    Return the minion options and pillar data
    """
    '''
    print(__name__)
    print(dir(__salt__))
    print(__salt__.loaded_modules)
    print(__salt__.loaded_files)
    for i in __salt__.items():
        print(i)
    for i in __opts__.items():
        print(i)
    for i in __utils__.items():
        print(i)
    print(__salt__.opts)
    print(__opts__)
    print(__opts__['pillar'])
    print(__opts__['pillar'])
    print(__opts__.get("beacons", "nada"))
    return True
    '''
    
    # Combining pillar and minion opts

    minion_config = {}
    pillar_data = __opts__.get("pillar", {})
    if not isinstance(pillar_data, dict):
        raise ValueError("Pillar must be of type dict.")
    minion_config.update(pillar_data)

    beacons_data = __opts__.get("beacons", {})
    if not isinstance(beacons_data, dict):
        raise ValueError("Beacons must be of type dict.")
    minion_config.update(beacons_data)

    return minion_config
