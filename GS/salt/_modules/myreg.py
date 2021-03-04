import salt.utils.platform

# Define the module's virtual name
__virtualname__ = "reg"


def __virtual__():
    """
    Only works on Windows systems
    """
    if salt.utils.platform.is_windows():
        return __virtualname__
    else:
        return (False, "only works on Windows")


def read_vdata(hive, key, vname=None, use_32bit_registry=False):
    return __salt__['reg.read_value'](hive, key, vname, use_32bit_registry)
