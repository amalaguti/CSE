import random
import logging
log = logging.getLogger(__name__)


def check_A():
    log.info(">>>>>>>> Engine check A")
    return _check()

def check_B():
    log.info(">>>>>>>> Engine check B")
    return _check()

def check_C():
    log.info(">>>>>>>> Engine check C")
    return _check()

def full_check():
    log.info(">>>>>>>> Engine full check")
    
    _check_A = check_A()
    _check_B = check_B()
    _check_C = check_C()
    resp = { 'check_A': _check_A, 'check_B': _check_B, 'check_C': _check_C } 

    if _check_A == True and _check_B == True and _check_C == True:
        __context__["retcode"] = 0
        log.info(">>>>>>>> Engine full check: All good {}".format(resp))
    else:
        __context__["retcode"] = 1
        log.info(">>>>>>>> Engine full check: Needs attention {}".format(resp))

    return resp

def _check(probability=0.8):
    '''
    Return random True/False with probability
    '''
    return(random.random() < probability)

