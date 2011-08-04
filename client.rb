require 'ruby-debug'
require './natwest.rb'
require './xero.rb'
require 'chronic'

credentials = YAML.load(File.read('credentials.yaml'))
natwest = Natwest.new credentials[:natwest]
natwest.login
file_paths = natwest.download_statements( Chronic.parse("3 weeks ago"), Time.now )

xero = Xero.new credentials[:xero]
xero.login!
xero.upload_statement! "privatebanking", file_paths.first
