import salt.utils.cloud
import salt.utils.stringutils
import salt.utils.files
import os
import tempfile
import logging
log = logging.getLogger(__name__)

def preseed_keys(minion):
    """Generate minion keys and auto-accept the minion."""
    priv_key, pub_key = salt.utils.cloud.gen_keys()
    accepted_key = os.path.join(__opts__['pki_dir'], 'minions', minion)
    with salt.utils.files.fopen(accepted_key, 'w') as fp_:
        fp_.write(salt.utils.stringutils.to_str(pub_key))

    tdir = tempfile.mkdtemp()
    priv_path = os.path.join(tdir, "minion.pem")
    pub_path = os.path.join(tdir, "minion.pub")
    log.info("Locate minion.pem {}".format(priv_path))
    log.info("Locate minion.pub {}".format(pub_path))
    with salt.utils.files.fopen(priv_path, 'w') as fp_:
        fp_.write(priv_key)
    with salt.utils.files.fopen(pub_path, 'w') as fp_:
        fp_.write(pub_key)

    return priv_key, pub_key
