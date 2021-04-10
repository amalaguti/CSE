"""
Runner Module for Sending Messages via SMTP
Using the existing smtp.py execution module

:depends:   - smtplib python module
:configuration: /etc/salt/master.d/smtp.conf

    For example:

    .. code-block:: yaml

        my-smtp-login:
            smtp.server: smtp.domain.com
            smtp.tls: "True" # Due to smtp.py execution module checking on "True" or "true" strings, not boolen
            smtp.sender: admin@domain.com
            smtp.username: myuser
            smtp.password: verybadpass
            smtp.password: verybadpass

"""


import logging
import os
import socket

import salt.utils.files

log = logging.getLogger(__name__)

HAS_LIBS = False
try:
    import smtplib
    import email.mime.text
    import email.mime.application
    import email.mime.multipart

    HAS_LIBS = True
except ImportError:
    pass


__virtualname__ = "smtp"


def __virtual__():
    """
    Only load this module if smtplib is available on this minion.
    """
    if HAS_LIBS:
        return __virtualname__
    return (False, "This module is only loaded if smtplib is available")


def send_msg(
    recipient,
    message,
    subject="Message from Salt",
    sender=None,
    server=None,
    use_ssl="True",
    username=None,
    password=None,
    profile=None,
    attachments=None,
):
    """
    Send a message to an SMTP recipient. To send a message to multiple \
    recipients, the recipients should be in a comma-seperated Python string. \
    Designed for use in states.

    CLI Examples:

    .. code-block:: bash

        salt-run smt.send_msg  'admin@example.com' 'This is a salt module test' profile='my-smtp-account'
        salt-run  smtp.send_msg 'admin@example.com,admin2@example.com' 'This is a salt module test for multiple recipients' profile='my-smtp-account'
        salt-run smtp.send_msg 'admin@example.com' 'This is a salt module test' username='myuser' password='verybadpass' sender='admin@example.com' server='smtp.domain.com'
        salt-run  smtp.send_msg 'admin@example.com' 'This is a salt module test' username='myuser' password='verybadpass' sender='admin@example.com' server='smtp.domain.com' attachments="['/var/log/messages']"
    """
    ret = __salt__['salt.cmd']('smtp.send_msg', recipient, message, subject=subject, sender=sender, server=server, use_ssl=use_ssl, username=username, password=password, profile=profile, attachments=attachments)


    return ret
