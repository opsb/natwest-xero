require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'

Capybara.configure do |config|
  config.default_driver = :webkit  
  config.run_server = false
  config.app_host   = 'https://login.xero.com/'
end

Capybara.current_session.driver.header('user-agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:2.0.1) Gecko/20110506 Firefox/4.0.1')

class Xero
  include Capybara
  attr_accessor :email, :password
  def initialize(credentials)
    credentials.each_pair{|name, value| send("#{name}=".to_sym, value)}        
  end
  
  def login
    visit 'https://login.xero.com'
    fill_in 'Email', :with => email
    fill_in 'Password', :with => password
    click_link 'Login'
  end
end