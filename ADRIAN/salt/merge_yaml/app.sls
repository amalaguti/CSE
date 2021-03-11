{% set show_data_only = salt['pillar.get']('show_data_only', False) %}

# Settings defaults
# 1 - Default settings (general)
{% set app_default = None %}
# 2 - Platform settings
{% set app_platform = None %}
# 3 - Environment settings (prod, qa, dev)
{% set app_environment = None %}
# 4 - Host specific settings
{% set app_host = None %}
# Final config
{% set app_config = {} %}



# Role default config
{% set rolespath = "roles/app" %}
{% import_yaml slspath ~ "/" ~ rolespath ~ "/app_default.yaml" as app_default %}

# Role platform config
{% if grains['os'] == 'RedHat' %}
{% import_yaml slspath ~ "/" ~ rolespath ~ "/app_" ~ grains['os'] ~ ".yaml" as app_platform %}
{% endif %}

# Environment config
{% set envs_prod = ['master', 'base'] %}
{% set envs_dev = ['dev'] %}
{% set envs_qa = ['qa'] %}
{% set minion_saltenv = salt['config.get']('saltenv', None) %}
{% if minion_saltenv == None or minion_saltenv in envs_prod %}
{% import_yaml slspath ~ "/" ~ rolespath ~ "/app_env_prod.yaml" as app_environment %}
{% elif minion_saltenv in envs_dev %}
{% import_yaml slspath ~ "/" ~ rolespath ~ "/app_env_dev.yaml" as app_environment %}
{% elif minion_saltenv in envs_qa %}
{% import_yaml slspath ~ "/" ~ rolespath ~ "/app_env_qa.yaml" as app_environment %}
{% endif%}


# Role host specific config
{% set hosts = ['saltmaster', 'minion1', 'minion2'] %}
{% if grains['id'] in hosts %}
{% import_yaml slspath ~ "/" ~ rolespath ~ "/app_" ~ grains['id'] ~ ".yaml" as app_host %}
{% endif %}


# Merge default, platform and host specific config elements to app_config
{% if app_default and app_default is mapping %}
{% set app_config = salt['slsutil.merge'](app_config, app_default) %}
{% endif %}
{% if app_platform and app_platform is mapping %}
{% set app_config = salt['slsutil.merge'](app_config, app_platform) %}
{% endif %}
{% if app_environment and app_environment is mapping %}
{% set app_config = salt['slsutil.merge'](app_config, app_environment) %}
{% endif %}
{% if app_host and app_host is mapping %}
{% set app_config = salt['slsutil.merge'](app_config, app_host) %}
{% endif %}



show_loaded_config_data:
  test.configurable_test_state:
    - name: show loaded config data
    - changes: False
    - result: True
    - comment: |
        app default config: {{ app_default }}

        app platform config: {{ app_platform }}

        app host config: {{ app_host }}

        app env config: {{ app_environment }} 




        -----------------------------------------------
        app config: {{ app_config }}




# Application config loaded - ready to start configuration

{% if show_data_only %}
showing_data_only:
  test.configurable_test_state:
    - name: Showing data only
    - changes: False
    - result: True
    - comment: Check data loaded
{% elif not show_data_only %}
appying_role:
  test.configurable_test_state:
    - name: Applying role
    - changes: True
    - result: True
    - comment: Let's get it done
{% endif %}
