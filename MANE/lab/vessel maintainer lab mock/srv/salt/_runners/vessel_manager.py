import logging

log = logging.getLogger(__name__)

def test():
    return True

def data_transmit(sat_transmitter='saltmaster'):
    log.info(">>>>>>>> Data satellite transmitter {}".format(sat_transmitter))    
    data_transmit_output = __salt__['salt.execute'](sat_transmitter, 'state.sls', arg=['vessel.transmit_data', 'pillar={}']).get(sat_transmitter, False)
    
    log.info(">>>>>>>> Data satellite result {}".format(data_transmit_output))    

    # If unable to contact sat_transmitter to send data
    # Run state locally to show error sending data
    if data_transmit_output == False:
        log.info(">>>>>>>> Data satellite transmitter is UNREACHABLE")    
        data_transmit_output = __salt__['salt.cmd']('state.sls', 'vessel.transmit_data_failed')

    return data_transmit_output


def engine_maintenance(minion='saltmaster', sat_transmitter='saltmaster', approved=None, devices=[]):
    '''
    Simulate running orchestration
    '''
    log.info(">>>>>>>> Vessel Maintenance runner")

    master_id = __opts__['id']

    if approved != True:
        # Request approval
        log.info(">>>>>>>> Vessel Maintenance runner checking for approval")
        approval = __salt__['vessel_ops_support.approval']()



    if approval == True:      
        log.info(">>>>>>>> Vessel Maintenance runner approved")
        approved = __salt__['salt.cmd']('state.sls', 'vessel.approval_approved')
        

        log.info(">>>>>>>> Maintenance of Engine {}".format(master_id))

        # Run orchestration
        resp = __salt__['state.orchestrate']('vessel.orch_maintenance', pillar={"minion": minion})
        log.info(">>>>>>>> Orchestration return: {}".format(resp))

        # remove 'out' key from salt.function return
        # This allows the highstate outputter to display the returned data from salt.function
        # when returned data is dictionary (no issues with string, int, boolean)
        resp['data'][master_id]['salt_|-engine_maintenance_check_|-vessel_engine.full_check_|-function']['changes'].pop('out', None)


        # Inject approved dict into orchestration return
        resp['data'][master_id].update(approved)

        # Get orchestration result
        orch_result = {}
        orch_result = resp['data'][master_id]
        #log.info(ret)


        # Send data if link is up
        data_transmit_result = {}
        for orch_step in orch_result.keys():
            log.info(">>>>>>>> Checking Maintenance result for step {}".format(orch_step))
            # Looking for state vessel_ops_support.satellite_conn_check (as shown in return dict)
            if "|-vessel_ops_support.satellite_conn_check_|" in orch_step:
                log.info(">>>>>>>> Checking Satellite link {}".format(orch_result[orch_step]))
                if orch_result[orch_step]['result'] == True:
                    log.info(">>>>>>>> Satlink UP, initiate data transfer")
                    data_transmit_result = data_transmit(sat_transmitter)
                    log.info(">>>>>>>> Satlink UP, finished data transfer: {}".format(data_transmit_result))
                else:
                    log.info(">>>>>>>> Satlink DOWN, hold on data transfer")



        # Update resp dict including minion execution (data transmit) by salt.execute
        if data_transmit_result != False:
            log.info(">>>>>>>> Injecting data_trasmit_result in response {}".format(data_transmit_result))
            resp['data'][master_id].update(data_transmit_result)

        log.info(">>>>>>>> Engine Maintenance complete: {}".format(resp))

        #return resp
    else:
        log.info(">>>>>>>> Vessel Maintenance runner rejected")
        rejected = __salt__['salt.cmd']('state.sls', 'vessel.approval_rejected')
        log.info(">>>>>>>> rejected response {}".format(rejected))
       
        # Prepare response with highstate outputter format and retcode 1
        resp = {}
        resp.update({'data': {master_id: rejected }, 'outputter': 'highstate', 'retcode': 1})
        #return resp

        
    return resp
