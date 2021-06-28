# -*- coding: utf-8 -*-
"""
The key Thorium State is used to apply changes to the accepted/rejected/pending keys

.. versionadded:: 2016.11.0
"""
# Import python libs
# It's no longer present in current version
# from __future__ import absolute_import, print_function, unicode_literals

import time
# Import salt libs
import salt.key



# AM
import logging
log = logging.getLogger(__name__)
import datetime as dt



# AM Function to check execution time in range
def check_time(start_time, end_time):
    start_time = int(start_time)
    end_time = int(end_time)
    current_hour = dt.datetime.now().hour

    if start_time < end_time:
        if current_hour >= start_time and current_hour < end_time:
            log.info(">>>>>>> Current time allows Thorium to remove keys")
            return True
    elif start_time > end_time:
        if current_hour >= start_time or current_hour < end_time:
            log.info(">>>>>>> Current time allows Thorium to remove keys")
            return True

    log.info(">>>>>>> Thorium WILL NOT remove keys at this time")
    return False




def _get_key_api():
    """
    Return the key api hook
    """
    if "keyapi" not in __context__:
        __context__["keyapi"] = salt.key.Key(__opts__)
    return __context__["keyapi"]


def timeout(name, start_time=0, end_time=24, delete=0, reject=0):
    """
    If any minion's status is older than the timeout value then apply the
    given action to the timed out key. This example will remove keys to
    minions that have not checked in for 300 seconds (5 minutes)

    USAGE:

    .. code-block:: yaml

        statreg:
          status.reg

        clean_keys:
          key.timeout:
            - require:
              - status: statreg
            - delete: 300
    """
    log.info(">>>>>>>>>>>>>>> CUSTOM THORIUM MODULE key.py !!!!!!!!")
    log.info(">>>>>>>>>>>>>>> THORIUM key.py THORIUM REGISTER {}".format(__reg__))
    # AM
    start_time = int(start_time)
    end_time = int(end_time)
    # 


    ret = {"name": name, "changes": {}, "comment": "", "result": True}
    now = time.time()
    ktr = "key_start_tracker"
    if ktr not in __context__:
        __context__[ktr] = {}
    log.info(">>>>>>>>>>>>>>> THORIUM key.py __context__[ktr] {}".format(__context__[ktr]))
    remove = set()
    reject_set = set()
    keyapi = _get_key_api()
    current = keyapi.list_status("acc")
    for id_ in current.get("minions", []):
        log.info(">>>>>>>>>>>>>>> THORIUM key.py checking __context__[ktr] {}".format(__context__[ktr]))
        log.info(">>>>>>>>>>>>>>> THORIUM key.py checking minion id {} ".format(id_))
        if id_ in __reg__["status"]["val"]:
            log.info(">>>>>>>>>>>>>>> THORIUM key.py MINION FOUND {} in register[status][val]".format(id_))
            # minion is reporting, check timeout and mark for removal
            if delete and (now - __reg__["status"]["val"][id_]["recv_time"]) > delete:
                log.info(">>>>>>>>>>>>>>> THORIUM key.py #1 minion {} reporting - delete - recv_time {} ".format(id_, __reg__["status"]["val"][id_]["recv_time"]))
                remove.add(id_)
            if reject and (now - __reg__["status"]["val"][id_]["recv_time"]) > reject:
                log.info(">>>>>>>>>>>>>>> THORIUM key.py #2 minion {} reporting - reject - recv_time {} ".format(id_, __reg__["status"]["val"][id_]["recv_time"]))
                reject_set.add(id_)
        else:
            # No report from minion recorded, mark for change if thorium has
            # been running for longer than the timeout
            log.info(">>>>>>>>>>>>>>> THORIUM key.py ** MINION NOT FOUND {} **in register[status][val]".format(id_))
            if id_ not in __context__[ktr]:
                __context__[ktr][id_] = now
            else:
                # AM
                log.info(">>>>>>>>>>>>>>> THORIUM key.py #3PRE minion {} now {} - context: {} vs delete {}".format(id_, now, now - __context__[ktr][id_], delete))
                ####
                if delete and (now - __context__[ktr][id_]) > delete:
                    log.info(">>>>>>>>>>>>>>> THORIUM key.py #3 minion {} not reporting - delete - ___context__[ktr][id_] {}".format(id_, __context__[ktr][id_]))
                    remove.add(id_)
                if reject and (now - __context__[ktr][id_]) > reject:
                    log.info(">>>>>>>>>>>>>>> THORIUM key.py #4 minion {} not reporting - reject - __context__[ktr][id_] {}".format(id_, __context__[ktr][id_]))
                    reject_set.add(id_)
     
    log.info(">>>>>>>>>>>>>>>>>>> key.py NEXT id_ >>>>>>>>>>>>>>>>>>")
    # AM TWEAK
    log.info(">>>>>>>>>>>>>>> THORIUM key.py #5 CHECK TIME")
    if check_time(start_time, end_time):
        log.info(">>>>>>>>>>>>>>> THORIUM key.py #6 remove {}".format(remove))
        # AM TWEAK
        if bool(remove):
            ret["comment"]: "Minion keys removed"
        #
        for id_ in remove:
            log.info(">>>>>>>>>>>>>>> THORIUM key.py DELETE KEY {}".format(id_))
            keyapi.delete_key(id_)

            ### AM TWEAK
            log.info(">>>>>>>>> Minion key deleted: %s" % id_)
            ret["changes"].update({id_: "deleted"})
            ###
            __reg__["status"]["val"].pop(id_, None)
            __context__[ktr].pop(id_, None)
            log.info(">>>>>>>>>>>>>>> THORIUM key.py MINION {} REMOVED".format(id_))
        for id_ in reject_set:
            keyapi.reject(id_)
            __reg__["status"]["val"].pop(id_, None)
            __context__[ktr].pop(id_, None)
            log.info(">>>>>>>>>>>>>>> THORIUM key.py MINION {} REJECTED".format(id_))
                 

    return ret
