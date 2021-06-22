"""
Runner Module for sqlite3
"""
 
def fetch_rows(db=None, sql=None):
    ret = __salt__['salt.cmd']('sqlite3.fetch_rows', db, sql)

    return ret

 
def modify(db=None, sql=None):
    ret = __salt__['salt.cmd']('sqlite3.modify', db, sql)

    return ret
