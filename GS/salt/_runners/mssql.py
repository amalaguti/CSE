"""
Runner Module for 

"""

def tsql_query(query, **kwargs):
    ret = __salt__['salt.cmd']('mssql.tsql_query', query, **kwargs)

    return ret
