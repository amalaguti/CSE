# -*- coding: utf-8 -*-
'''
Runner to execute modules only on minions that are up

# salt-run saltutil.sync_runners
# salt-run run_up_throttle.exec_luks_check_throttle
#           timeout=1
#           gather_job_timeout=1
#           throttle=2
#           show_job_output=True

'''
# Import python libs
from __future__ import absolute_import, print_function, unicode_literals
from datetime import datetime
import logging
import json

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
        salt-run run_up_throttle.status
        salt-run run_up_throttle.status tgt="webservers" tgt_type="nodegroup"
        salt-run run_up_throttle.status timeout=5 gather_job_timeout=10
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
        salt-run run_up_throttle.up
        salt-run run_up_throttle.up tgt="webservers" tgt_type="nodegroup"
        salt-run run_up_throttle.up timeout=5 gather_job_timeout=10
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
        salt-run run_up_throttle.execute_version
        salt-run run_up_throttle.execute_version tgt="webservers" tgt_type="nodegroup"
        salt-run run_up_throttle.execute_version timeout=5 gather_job_timeout=10
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


def exec_luks_check_throttle(tgt='*', tgt_type='glob', timeout=None, gather_job_timeout=None, throttle=10, show_job_output=False):
    '''
    Exec function on minions that are up
    CLI Example:
    .. code-block:: bash
        salt-run run_up_throttle.exec_luks_check_throttle
        salt-run run_up_throttle.exec_luks_check_throttle tgt="webservers" tgt_type="nodegroup"
        salt-run run_up_throttle.exec_luks_check_throttle timeout=5 gather_job_timeout=10
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

    if throttle > minions_count:
        # Equal throttle to minions count
        throttle = minions_count

    minions_tgt_list = ','.join(ret)

    # Run the job
    if minions_count < throttle:
        # Execute full list
        ret = do_the_job(minions_tgt_list.split(','))
    else:
        # Execute in batches based on throttle
        throttle_list = []
        throttle_lists = []

        # Generate throttle lists
        for minion in ret:
            if len(throttle_list) == throttle:
                throttle_lists.append(throttle_list)
                throttle_list = []
                throttle_list.append(minion)
            else:
                throttle_list.append(minion)
        throttle_lists.append(throttle_list)

        ret = do_the_job(throttle_lists)

    if show_job_output == True:
        return True, json.dumps(ret, indent=4, sort_keys=True)
    else:
        return True


def do_the_job(throttle_lists):
    # Run luks_check and set grains
    print("DOING THE JOB: ")

    exec_ret_lists = []
    for minions_tgt_list in throttle_lists:
        # Execute luks_check.get_disks_encrypted on minion
        exec_ret = __salt__['salt.execute'](minions_tgt_list, 'luks_check.get_disks_encrypted', tgt_type='list')
        exec_ret_lists.append(exec_ret)


        for minion in exec_ret:
            #print(exec_ret[minion])

            # datetime object containing current date and time
            now = datetime.now()
            # dd/mm/YY H:M:S
            dt_string = now.strftime("%d/%m/%Y %H:%M:%S")

            # Set grains based on luks_check execution result True/False
            if exec_ret[minion] == False:
                grains = {'runner_luks_encrypted': False, 'Time': dt_string, 'test': True}
                exec_ret[minion] = __salt__['salt.execute'](minion, 'grains.set', arg=('luks:runner_exec', grains), kwarg={'force': True})
            else:
                grains = {'runner_luks_encrypted': True, 'Time': dt_string, 'test': True}
                exec_ret[minion] = __salt__['salt.execute'](minion, 'grains.set', arg=('luks:runner_exec', grains), kwarg={'force': True})


    return exec_ret_lists
