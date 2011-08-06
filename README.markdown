natwest-xero
============

Library for syncing natwest accounts with xero

Setup
-----

You need the following details in natwest-xero/credentials.yaml

    ---
    :natwest:
      :password: password
      :pin: '1234'
      :customer_number: 'ddmmyyxxxx'
    :xero:
      :email: jim@example.com
      :password: password1  
    :accounts:
      - !ruby/struct:Account
        name: name_of_account_in_xero
        sort_code: '123456'
        account_number: '12345678'
      - !ruby/struct:Account
        name: name_of_account_in_xero
        sort_code: '123456'
        account_number: '12345678'


Usage
-----

    # sync last 16 weeks
    $ bundle exec rake sync

    # sync last 2 days - can be anything that https://github.com/mojombo/chronic understands
    $ SYNC_FROM="2 days ago" bundle exec rake sync

NB: Very wip