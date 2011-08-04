require 'rubygems'
require 'rake'
require './lib/natwest-xero.rb'

task :cron do
  Rake::Task[:sync].execute
end

task :sync do
  SyncJob.new.perform
end