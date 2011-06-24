require 'ruby-debug'
require './natwest.rb'
require './xero.rb'
require 'chronic'

credentials = YAML.load(File.read('credentials.yaml'))
natwest = Natwest.new credentials[:natwest]
natwest.login
natwest.download_statements Chronic.parse("3 weeks ago"), Time.now