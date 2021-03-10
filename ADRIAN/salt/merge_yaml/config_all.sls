  # cat config_all.sls
{% import_yaml slspath ~ "/config_dev.yaml" as config_dev %}
{% import_yaml slspath ~ "/config_dev.yaml" as config_devA %}
{% import_yaml slspath ~ "/config_prod.yaml" as config_prod %}
{% set all_defaults = salt['defaults.merge'](config_dev, config_prod, in_place=False) %}


{% set all_merge_list = salt['slsutil.merge'](config_dev, config_prod, strategy='list') %}
{% set all_merge_smart = salt['slsutil.merge'](config_dev, config_prod) %}
{% set all_merge_ow = salt['slsutil.merge'](config_dev, config_prod, strategy='overwrite') %}

show:
  test.configurable_test_state:
    - name: show
    - changes: False
    - result: True
    - comment: |
        dev                      : {{ config_devA }}
        prod                     : {{ config_prod }}
        defaults.merge           : {{ all_defaults }}
        slsutil.merge            : {{ all_merge_smart }}
        slsutil.merge_overwrite  : {{ all_merge_ow }}
        slsutil.merge_list       : {{ all_merge_list }}


{#

local:
----------
          ID: show
    Function: test.configurable_test_state
      Result: True
     Comment: dev                      : {'db': {'name': 'ABC', 'env': 'dev', 'dev_code': 12345, 'common_code': 'this is dev'}}
              prod                     : {'db': {'name': 'ABC', 'env': 'prod', 'pro_code': 54321, 'common_code': 'this is prod'}}
              defaults.merge           : {'db': {'name': 'ABC', 'env': 'prod', 'dev_code': 12345, 'common_code': 'this is prod', 'pro_code': 54321}}
              slsutil.merge            : {'db': {'name': 'ABC', 'env': 'prod', 'dev_code': 12345, 'common_code': 'this is prod', 'pro_code': 54321}}
              slsutil.merge_overwrite  : {'db': {'name': 'ABC', 'env': 'prod', 'pro_code': 54321, 'common_code': 'this is prod'}}
              slsutil.merge_list       : {'db': [{'name': 'ABC', 'env': 'dev', 'dev_code': 12345, 'common_code': 'this is dev'}, {'name': 'ABC', 'env': 'prod', 'pro_code': 54321, 'common_code': 'this is prod'}]}
     Started: 19:21:19.840977
    Duration: 1.956 ms
     Changes:


# cat config_dev.yaml
db:
  name: ABC
  env: dev
  dev_code: 12345
  common_code: this is dev

# cat config_prod.yaml
db:
  name: ABC
  env: prod
  pro_code: 54321
  common_code: this is prod

#}
