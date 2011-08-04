# coding: utf-8
require 'mechanize'

class Natwest
  URL = 'https://nwolb.com/'
  attr_reader :ua, :pin, :page, :accounts
  attr_accessor :password, :pin, :customer_number, :page, :accounts
  
  def assert(condition, message)
    raise message unless condition
  end    
  
  def initialize(credentials)
    credentials.each_pair{|name, value| send("#{name}=".to_sym, value)}    
    @ua = Mechanize.new {|ua| ua.user_agent_alias = 'Windows IE 7'}    
  end
  
  def login!
    enter_customer_number
    enter_pin_and_password
    confirm_last_login
    @logged_in = true
  end  
  
  def download_statements(start_date, end_date)
    accounts.map do |account|
      download_statement("#{account[:sort_code]}-#{account[:account_number]}", start_date, end_date)      
    end
  end
  
  def download_statement(account, start_date, end_date)
    download_transactions_page =
      @ua.get("https://www.nwolb.com/StatementsDownloadSpecificDates.aspx")
    download_transactions_page.body 
    accounts_form = download_transactions_page.forms.first
    form_values = {
      'A_day' => start_date.day,
      'A_month' => start_date.month,
      'A_year' => start_date.year,
      'B_day' => end_date.day,
      'B_month' => end_date.month,
      'B_year' => end_date.year
      
    }
    accounts_form.fields.each do |field|
      field_name = field.name[/([AB]_[^_]+)$/, 1]
      field.value = form_values[field_name] if field_name
    end    
    accounts_form.fields.find{ |field| field.name == "ctl00$mainContent$SS8SDDDA"}.value = "2"
    accounts_form.checkbox_with(:name => Regexp.new(account)).check
    download_form = @ua.submit(accounts_form).forms.first
    download_button = download_form.button_with(:value => /Download transactions/)
    transactions_file = @ua.submit(download_form, download_button)
    file_path = File.expand_path("~/Desktop/transactions-#{account}.ofx")
    transactions_file.save(file_path)    
    file_path
  end

  private
  def enter_customer_number
    login_form = ua.get(URL).frames.first.click.forms.first
    login_form['ctl00$mainContent$LI5TABA$DBID_edit'] = customer_number
    self.page = login_form.submit
    assert(page.title.include?('PIN and Password details'), 
           "Got '#{page.title}' instead of PIN/Password prompt")
  end

  def enter_pin_and_password
    expected = expected('PIN','number') + expected('Password','character')
    self.page = page.forms.first.tap do |form|
     ('A'..'F').map do |letter| 
       "ctl00$mainContent$Tab1$LI6PPE#{letter}_edit"
      end.zip(expected).each {|field, value| form[field] = value}
    end.submit
    assert(page.title.include?('Last log in confirmation'), 
           "Got '#{page.title}' instead of last login confirmation")
  end

  def confirm_last_login
    self.page = page.forms.first.submit
    assert(page.title.include?('Accounts summary'), 
           "Got '#{page.title}' instead of accounts summary")
  end

  def expected(credential, type)
    page.body.
         scan(/Enter the (\d+)[a-z]{2} #{type}/).
    flatten.map{|i| i.to_i - 1}.tap do |indices|
      assert(indices.uniq.size == 3, 
             "Unexpected #{credential} characters requested")
      characters = [*send(credential.downcase.to_sym).to_s.chars]
      indices.map! {|i| characters[i]}
    end
  end
end
