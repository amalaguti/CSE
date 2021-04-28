"""
Runner Module for 

"""

def tsql_query(query, **kwargs):
    ret = __salt__['salt.cmd'](query, **kwargs)

    return ret
