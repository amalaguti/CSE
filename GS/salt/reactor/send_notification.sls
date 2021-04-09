# event.send 'send/notification' '{"alert": "red", "system": "sdc-01"}'

# cat /etc/salt/master.d/smtp.conf
#my-smtp-login:
#  smtp.server: email-smtp.us-east-2.amazonaws.com
#  smtp.tls: True
#  smtp.sender: adrian.malaguti@turtletraction.com
#  smtp.username: 
#  smtp.password: 
  
  
send_email:
  runner.smtp.send_msg:
    - args:
        - recipient: 'adrianma78@hotmail.com'
        - message: |
            check what is going on {{ data["data"]["system"] }}
            {{ data }}
        - subject: 'Salt - Alarm code {{ data["data"]["alert"] }} from {{ data["id"] }}'
        - profile: 'my-smtp-login'
