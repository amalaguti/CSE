# -*- coding: utf-8 -*-
"""
Custom module Support for SQLite3
"""
from __future__ import absolute_import, print_function, unicode_literals
# Import python libs
try:
    import sqlite3

    HAS_SQLITE3 = True
except ImportError:
    HAS_SQLITE3 = False


import logging
log = logging.getLogger(__name__)

__virtualname__ = "sqlite3"


def __virtual__():
    if not HAS_SQLITE3:
        return (
            False,
            "The sqlite3 execution module failed to load: the sqlite3 python library is not available.",
        )
    return __virtualname__


def _connect(db=None):
    if db is None:
        return False

    con = sqlite3.connect(db, isolation_level=None)
    cur = con.cursor()
    return cur


def fetch_rows(db=None, sql=None):
    """
    Retrieve data from an sqlite3 db (returns all rows, be careful!)
    Each row is shown in a single line

    CLI Example:

    .. code-block:: bash

        salt '*' sqlite3.fetch_rows /root/test.db 'SELECT * FROM test;'
    """
    cur = _connect(db)

    if not cur:
        return False

    cur.execute(sql)
    #rows = cur.fetchall()
    #return rows

    res = cur.fetchall()

    if not res:
        return None

    rows = []
    for row in res:
        rows.append(','.join(row))

    return rows
