# -*- coding: utf-8 -*-
"""
SQLite sdb fixed Module
https://github.com/saltstack/salt/issues/58533
"""
from __future__ import absolute_import, print_function, unicode_literals

import codecs

# Import python libs
import logging

# Import salt libs
import salt.utils.msgpack
from salt.ext import six

try:
    import sqlite3

    HAS_SQLITE3 = True
except ImportError:
    HAS_SQLITE3 = False


DEFAULT_TABLE = "sdb"

log = logging.getLogger(__name__)

__func_alias__ = {"set_": "set"}


def __virtual__():
    """
    Only load if sqlite3 is available.
    """
    if not HAS_SQLITE3:
        return False
    return True


def _quote(s, errors="strict"):
    encodable = s.encode("utf-8", errors).decode("utf-8")

    nul_index = encodable.find("\x00")

    if nul_index >= 0:
        error = UnicodeEncodeError(
            "NUL-terminated utf-8",
            encodable,
            nul_index,
            nul_index + 1,
            "NUL not allowed",
        )
        error_handler = codecs.lookup_error(errors)
        replacement, _ = error_handler(error)
        encodable = encodable.replace("\x00", replacement)

    return '"' + encodable.replace('"', '""') + '"'


def _connect(profile):
    db = profile["database"]
    table = None
    conn = sqlite3.connect(db)
    cur = conn.cursor()
    stmts = profile.get("create_statements")
    table = profile.get("table", DEFAULT_TABLE)
    idx = _quote(table + "_idx")
    table = _quote(table)

    try:
        if stmts:
            for sql in stmts:
                cur.execute(sql)
        elif profile.get("create_table", True):
            cur.execute(("CREATE TABLE {0} (key text, " "value blob)").format(table))
            cur.execute(("CREATE UNIQUE INDEX {0} ON {1} " "(key)").format(idx, table))
    except sqlite3.OperationalError:
        pass

    return (conn, cur, table)


def set_(key, value, profile=None):
    """
    Set a key/value pair in sqlite3
    """
    log.info(">>>>>>>> value: {}".format(value))
    if not profile:
        return False
    conn, cur, table = _connect(profile)
    log.info(">>>>>>>> Skipping value conversion ")
    ''' ADRIAN: string values get converted to byte object which causes
        issues with sqlite3.fetch
    if six.PY2:
        # pylint: disable=undefined-variable
        value = buffer(salt.utils.msgpack.packb(value))
        # pylint: enable=undefined-variable
        log.info(">>>>>>>> buffer msgpack value: {} {}".format(value, type(value)))
    else:
        value = memoryview(salt.utils.msgpack.packb(value))
        log.info(">>>>>>>> memoryview msgpack: {} {}".format(value, type(value)))
    '''
    q = profile.get(
        "set_query",
        ("INSERT OR REPLACE INTO {0} VALUES " "(:key, :value)").format(table),
    )
    conn.execute(q, {"key": key, "value": value})
    conn.commit()
    return True


def get(key, profile=None):
    """
    Get a value from sqlite3
    """
    if not profile:
        return None
    _, cur, table = _connect(profile)
    q = profile.get(
        "get_query", ("SELECT value FROM {0} WHERE " "key=:key".format(table))
    )
    log.info(">>>>>>>> profile query: {}".format(q))

    res = cur.execute(q, {"key": key})
    #res = res.fetchone()
    res = res.fetchall()
    if not res:
        return None


    #return salt.utils.msgpack.unpackb(res[0])
    rows = []
    for row in res:
        rows.append(','.join(row))

    return rows
