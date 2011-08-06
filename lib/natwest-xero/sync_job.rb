require 'fileutils'

class SyncJob
  include FileUtils
  
  def perform
    credentials = ENV['CREDENTIALS'] || YAML.load(File.read('credentials.yaml'))

    natwest = Natwest.new credentials[:natwest]
    natwest.login!

    xero = Xero.new credentials[:xero]
    xero.login!

    credentials[:accounts].each do |account|
      puts "Starting sync for #{account.id}"
      file_path = natwest.download_statement( account.id, Chronic.parse(ENV['SYNC_FROM'] || "16 weeks ago"), Time.now )
      xero.upload_statement! account, file_path
      rm file_path
      puts "Completed sync for #{account.id}"
    end  
  end
end