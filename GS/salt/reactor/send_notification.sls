# event.send 'send/notification' '{"alert": "red", "system": "sdc-01"}'


send_email:
  runner.smtp.send_msg:
    - args:
        - recipient: 'adrianma78@hotmail.com'
        - message: 'check what is going on {{ data["data"]["system"] }}'
        - subject: 'Salt - Alarm code {{ data["data"]["alert"] }} from {{ data["id"] }}'
        - profile: 'my-smtp-login'
