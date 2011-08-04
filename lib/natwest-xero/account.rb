class Account < Struct.new(:name, :sort_code, :account_number)
  def id
    "#{sort_code}-#{account_number}"
  end
  
  def xero_url_name
    name.gsub("\s", "")    
  end
end