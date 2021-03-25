"""
Send events covering registry keys
"""
import logging
import os
import time

log = logging.getLogger(__name__)

__virtualname__ = "registry"

def beacon(config):
    """
    Scan for the configured registry keys and fire events
    Example Config
    .. code-block:: yaml
        beacons:
          registry:
            - keys:
                salt-master: {}
                mysql: {}
    """

    log.info(">>>>> BEACONS REGISTRY")
    ret = []
    _config = {}
    list(map(_config.update, config))

    for reg_entry in _config.get("entries", {}):
        ret_dict = {}

        reg_entry_config = _config["entries"][reg_entry]

        reg_entry_check = __salt__["reg.read_value"](reg_entry_config['hive'], reg_entry_config['key'], vname=reg_entry_config['vname'])

        if not reg_entry_check['success'] and reg_entry_config['on_not_found'] == True:
            log.info(">>>> Beacon registry ENTRY NOT FOUND {}".format(reg_entry))
            ret_dict[reg_entry] = "NOT FOUND"
            ret_dict["reg_entry"] = reg_entry
            ret_dict["tag"] = reg_entry
            ret.append(ret_dict)

        if reg_entry_check['success'] and (reg_entry_config['value'] != reg_entry_check['vdata']):
            log.info(">>>> Beacon registry {} MISMATCH {}".format(reg_entry_config['value'], reg_entry_check['vdata']))
            ret_dict[reg_entry] = reg_entry_check
            ret_dict["reg_entry"] = reg_entry
            ret_dict["expected_value"] = reg_entry_config['value']
            ret_dict["tag"] = reg_entry
            log.info("_________ NOT FOUND {}".format(ret_dict))
            ret.append(ret_dict)

    return ret
