# -*- coding: utf-8 -*-
"""
Module to provide INSERT/UPDATE support for mssql module
:depends:   - FreeTDS
            - pymssql Python module
            - mssql.py Salt module
"""

# Import python libs
from __future__ import absolute_import, print_function, unicode_literals

# Import Salt libs
import salt.ext.six as six
import salt.utils.json


import logging
log = logging.getLogger(__name__)

# Define the module's virtual name
#__virtualname__ = "mssql"

try:
    import pymssql

    HAS_ALL_IMPORTS = True
except ImportError:
    HAS_ALL_IMPORTS = False

_DEFAULTS = {
    "server": "localhost",
    "port": 1433,
    "user": "sysdba",
    "password": "",
    "database": "",
    "as_dict": False,
}


def __virtual__():
    """
    Only load this module if all imports succeeded bin exists
    """
    if HAS_ALL_IMPORTS:
        #return __virtualname__
        return True
    return (
        False,
        "The mssql execution module cannot be loaded: the pymssql python library is not available.",
    )

def _get_connection(**kwargs):
    connection_args = {}
    for arg in ("server", "port", "user", "password", "database", "as_dict"):
        if arg in kwargs:
            connection_args[arg] = kwargs[arg]
        else:
            connection_args[arg] = __salt__["config.option"](
                "mssql." + arg, _DEFAULTS.get(arg, None)
            )
    return pymssql.connect(**connection_args)


class _MssqlEncoder(salt.utils.json.JSONEncoder):
    # E0202: 68:_MssqlEncoder.default: An attribute inherited from JSONEncoder hide this method
    def default(self, o):  # pylint: disable=E0202
        return six.text_type(o)


def tsql_query2(query, **kwargs):
    """
    Run a SQL query and return query result as list of tuples, or a list of dictionaries if as_dict was passed, or an empty list if no data is available.

    CLI Example:

    .. code-block:: bash

        salt minion mssql.tsql_query 'SELECT @@version as version' as_dict=True
    """
    #try:
    cur = _get_connection(**kwargs).cursor()
    log.info(">>>>>>> cur: {}".format(cur))
    cur.execute(query)
    log.info(">>>>>>> cur: {}".format(cur))
    log.info(">>>>>>> cur: {}".format(cur.rowcount))
    # Making sure the result is JSON serializable
    return salt.utils.json.loads(
            _MssqlEncoder().encode({"resultset": cur.fetchall()})
        )["resultset"]
    #except Exception as err:  # pylint: disable=broad-except
    #    # Trying to look like the output of cur.fetchall()
    #    return (("Could not run the query",), (six.text_type(err),))
