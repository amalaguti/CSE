# -*- coding: utf-8 -*-
'''
Runner to execute modules only on minions that are up
'''
# Import python libs
from __future__ import absolute_import, print_function, unicode_literals
from datetime import datetime
import logging

# Import 3rd-party libs
from salt.ext import six

# Import salt libs
import salt.client


log = logging.getLogger(__name__)


def _ping(tgt, tgt_type, timeout, gather_job_timeout):
    client = salt.client.get_local_client(__opts__['conf_file'])
    pub_data = client.run_job(tgt, 'test.ping', (), tgt_type, '', timeout, '', listen=True)

    if not pub_data:
        return pub_data

    log.debug(
        'manage runner will ping the following minion(s): %s',
        ', '.join(sorted(pub_data['minions']))
    )

    returned = set()
    for fn_ret in client.get_cli_event_returns(
            pub_data['jid'],
            pub_data['minions'],
            client._get_timeout(timeout),
            tgt,
            tgt_type,
            gather_job_timeout=gather_job_timeout):

        if fn_ret:
            for mid, _ in six.iteritems(fn_ret):
                log.debug('minion \'%s\' returned from ping', mid)
                returned.add(mid)

    not_returned = sorted(set(pub_data['minions']) - returned)
    returned = sorted(returned)

    return returned, not_returned

def status(output=True, tgt='*', tgt_type='glob', timeout=None, gather_job_timeout=None):
    '''
    .. versionchanged:: 2017.7.0
        The ``expr_form`` argument has been renamed to ``tgt_type``, earlier
        releases must use ``expr_form``.
    Print the status of all known salt minions
    CLI Example:
    .. code-block:: bash
        salt-run run_up.status
        salt-run run_up.status tgt="webservers" tgt_type="nodegroup"
        salt-run run_up.status timeout=5 gather_job_timeout=10
    '''
    ret = {}

    if not timeout:
        timeout = __opts__['timeout']
    if not gather_job_timeout:
        gather_job_timeout = __opts__['gather_job_timeout']

    res = _ping(tgt, tgt_type, timeout, gather_job_timeout)
    ret['up'], ret['down'] = ([], []) if not res else res
    return ret

def up(tgt='*', tgt_type='glob', timeout=None, gather_job_timeout=None):  # pylint: disable=C0103
    '''
    .. versionchanged:: 2017.7.0
        The ``expr_form`` argument has been renamed to ``tgt_type``, earlier
        releases must use ``expr_form``.
    Print a list of all of the minions that are up
    CLI Example:
    .. code-block:: bash
        salt-run run_up.up
        salt-run run_up.up tgt="webservers" tgt_type="nodegroup"
        salt-run run_up.up timeout=5 gather_job_timeout=10
    '''
    ret = status(
        output=False,
        tgt=tgt,
        tgt_type=tgt_type,
        timeout=timeout,
        gather_job_timeout=gather_job_timeout
    ).get('up', [])
    return ret


def execute_version(tgt='*', tgt_type='glob', timeout=None, gather_job_timeout=None):
    '''
    Exec test.version on minions that are up
    CLI Example:
    .. code-block:: bash
        salt-run run_up.execute_version
        salt-run run_up.execute_version tgt="webservers" tgt_type="nodegroup"
        salt-run run_up.execute_version timeout=5 gather_job_timeout=10
    '''

    # Get minions up
    ret = up(
        tgt=tgt,
        tgt_type=tgt_type,
        timeout=timeout,
        gather_job_timeout=gather_job_timeout
    )

    # Execute on minions up
    exec_ret = {}

    for minion in ret:
        exec_ret[minion] = __salt__['salt.execute'](minion, 'test.version')


    return exec_ret


def execute_luks_check(tgt='*', tgt_type='glob', timeout=None, gather_job_timeout=None, throttle=10):
    '''
    Exec function on minions that are up
    CLI Example:
    .. code-block:: bash
        salt-run run_up.execute_luks_check
        salt-run run_up.execute_luks_check tgt="webservers" tgt_type="nodegroup"
        salt-run run_up.execute_luks_check timeout=5 gather_job_timeout=10
    '''

    # Get minions up
    ret = up(
        tgt=tgt,
        tgt_type=tgt_type,
        timeout=timeout,
        gather_job_timeout=gather_job_timeout
    )

    # datetime object containing current date and time
    now = datetime.now()
    # dd/mm/YY H:M:S
    dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
    
    # Execute on minions up
    exec_ret = {}

    # Throttling execution
    minions_tgt_list = ''
    minions_count = len(ret)
    print("Throttle: " + str(throttle))
    print("Minions count: " + str(minions_count))
    
    if minions_count <= throttle:
        # Execute full list
        # Create target list
        minions_tgt_list = ','.join(ret)
        print(minions_tgt_list)
    
        # Execute luks_check.get_disks_encrypted on minion
        exec_ret = __salt__['salt.execute'](minions_tgt_list, 'luks_check.get_disks_encrypted', tgt_type='list')
        print(exec_ret)
    else:
        # Execute in batches based on throtle
        throttle_range = range(throttle+1)
        for i in throttle_range:
            print(i)
    
    '''
    for minion in ret:
        # Execute luks_check.get_disks_encrypted on minion
        exec_ret[minion] = __salt__['salt.execute'](minion, 'luks_check.get_disks_encrypted')


        # datetime object containing current date and time
        now = datetime.now()
        # dd/mm/YY H:M:S
        dt_string = now.strftime("%d/%m/%Y %H:%M:%S")

        # Set grains based on luks_check execution result True/False
        if exec_ret[minion][minion] == False:
            grains = {'runner_luks_encrypted': False, 'Time': dt_string, 'test': True}
            exec_ret[minion] = __salt__['salt.execute'](minion, 'grains.set', arg=('luks:runner_exec', grains), kwarg={'force': True})
        else:
            grains = {'runner_luks_encrypted': True, 'Time': dt_string, 'test': True}
            exec_ret[minion] = __salt__['salt.execute'](minion, 'grains.set', arg=('luks:runner_exec', grains), kwarg={'force': True})


    return exec_ret
    '''
    
    return True
