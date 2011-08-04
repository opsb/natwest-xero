require 'ruby-debug'
require './natwest.rb'
require './xero.rb'
require 'chronic'

credentials = YAML.load(File.read('credentials.yaml'))

natwest = Natwest.new credentials[:natwest]
natwest.login

xero = Xero.new credentials[:xero]
xero.login!

credentials[:natwest][:accounts].each do |account|
  file_path = natwest.download_statement( "#{account[:sort_code]}-#{account[:account_number]}", Chronic.parse("16 weeks ago"), Time.now )
  xero.upload_statement! account, file_path
end

