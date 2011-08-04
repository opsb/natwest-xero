require 'chronic'

%w{natwest xero account sync_job}.each do |file|
  require File.join(File.expand_path(File.dirname(__FILE__)), "natwest-xero", file)
end