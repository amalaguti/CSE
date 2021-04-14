import random
import logging

log = logging.getLogger(__name__)

def files_retrieval():
    # get files 
    log.info(">>>>>>>> Vessel Ops Support runner")
    log.info(">>>>>>>> Vessel Ops Support files retrieval")
    return True


def satellite_conn_check():
    log.info(">>>>>>>> Vessel Ops Support runner")
    log.info(">>>>>>>> Vessel Ops Support satellite connection check")
    return True
   

def approval():
    return _check()


def _check(probability=0.8):
    '''
    Return random True/False with probability
    '''
    return(random.random() < probability)
