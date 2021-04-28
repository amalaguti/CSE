"""
Runner Module for 

"""

def tsql_query(query, **kwargs):
    ret = __salt__['salt.cmd']('mssql.tsql_query', query, **kwargs)

    return ret


def tsql_insert(query, **kwargs):
    ret = __salt__['salt.cmd']('mssql.tsql_insert', query, **kwargs)

    return ret
