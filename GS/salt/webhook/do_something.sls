{% set post = salt['pillar.get']('event_post', {}) %}
{% set stamp = salt['pillar.get']('event_stamp', {}) %}

# Filtering in the state by hostname pattern
# To use when tgt: *
# NOTE: less preferred option due targeting all minions, better filter in reactor

show:
  test.configurable_test_state:
    - name: show post data
    - changes: false
    - result: True
    - comment: |
        {{ post }}

{% if 'tgt' in post and post['tgt'] in grains['id'] %}
# Get keys from dict,  set defaults to prevent errors due to non existing key
{% set phone = post.get('phone', 'no phone') %}
{% set watch = post.get('watch', 'time running') %}
append_to_file:
  file.append:
    - name: /tmp/do_something.txt
    - text: |
        Use phone to call {{ phone }}
        Meanwhile sit down and watch {{ watch }}
        {{ stamp }}
{% endif %}
