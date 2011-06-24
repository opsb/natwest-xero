natwest-xero
============

Library for syncing natwest accounts with xero

Setup
-----

You need the following details in natwest-xero/credentials.yaml

    --- 
    :natwest: 
      :password: password
      :pin: "1234"
      :customer_number: "ddmmyynnnn"
      :accounts: 
      - 603030-12345678
    :xero:
      :email: ben@gmail.com
      :password: password

Usage
-----

    $ bundle exec 

NB: Very wip