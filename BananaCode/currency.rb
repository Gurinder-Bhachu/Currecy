require 'net/http'
require 'json'
class TestResponce
  @success_url = 'https://bananabudget.azurewebsites.net/?startDate=10-12-2017&numberOfDays=20'
  @url_with_missing_days = 'https://bananabudget.azurewebsites.net/?startDate=10-12-2017&numberOfDays='
  @url_with_missing_date = 'https://bananabudget.azurewebsites.net/?startDate=&numberOfDays=200'
  @invalid_days = 'https://bananabudget.azurewebsites.net/?startDate=10-12-2017&numberOfDays=3333333'
  @invalid_start_date = 'https://bananabudget.azurewebsites.net/?startDate=1afds&numberOfDays=100'
  @days_are_366 ='https://bananabudget.azurewebsites.net/?startDate=10-12-2017&numberOfDays=366'

  def self.success(expected)
    puts 'Test Case 1 "checking success case" :- '
    @uri = URI(@success_url)
    response = Net::HTTP.get_response(@uri)
    @result = response.code.to_i
    puts @uri.host == 'bananabudget.azurewebsites.net' ?  "   Verified host: '#{@uri.host}' is Valid"  : "False host is invalid #{@uri.host}"
    puts @uri.query != nil? ? "   Verified Parameteres of success responce'#{@uri.query}'" : "Something is wrong, Getting Wrong Param #{@uri.query}"
    puts @result==expected ? "  'Success' getting #{expected}" : "Failed Responce code is #{@result}"
  end

  def self.check_missing_days(expected, status_code_should_be)
    puts # just an empty line so result can be easy read able
    puts 'Test Case 2 "checking missing days case" :- '
    @uri = URI(@url_with_missing_days)
    response = Net::HTTP.get_response(@uri)
    missing_days_responce = JSON.parse(response.body)
    puts missing_days_responce['error'] == expected ? " Valid Responce:-  '#{expected}'" : " 'Wrong body responce, Getting #{missing_days_responce} it should be #{expected}"
    @should_get_400_code = response.code.to_i
    puts @should_get_400_code ==  status_code_should_be ? " 'Success' getting #{@should_get_400_code}" : "Failed Responce code is #{@result}"
  end

  def self.check_missing_date(expected,status_code_should_be)
    puts # just an empty line so result can be easy read able
    puts 'Test Case 3 "checking missing date case" :- '
    @uri = URI(@url_with_missing_date)
    response = Net::HTTP.get_response(@uri)
    missing_date_responce = JSON.parse(response.body)
    puts missing_date_responce['error'] == expected ? " Valid Responce:-  '#{expected}'" : " 'Wrong body responce, Getting #{missing_date_responce} it should be #{expected}"
    @should_get_400_code = response.code.to_i
    puts @should_get_400_code ==  status_code_should_be ? " 'Success' getting #{@should_get_400_code}" : "Failed Responce code is #{@result}"
  end

  def self.invalid_days(expected, status_code_should_be)
    puts # just an empty line so result can be easy read able
    puts 'Test Case 4 "checking invalid days" :- '
    @uri = URI(@invalid_days)
    response = Net::HTTP.get_response(@uri)
    invalid_days_response = JSON.parse(response.body)
    puts invalid_days_response['error'] == expected ? " Valid Responce:-  '#{expected}'" : " 'Wrong body responce, Getting #{invalid_days_response} it should be #{expected}"
    @should_get_400_code = response.code.to_i
    puts @should_get_400_code ==  status_code_should_be ? " 'Success' getting #{@should_get_400_code}" : "Failed Responce code is #{@result}"
  end

  def self.invalid_start_date(expected, status_code_should_be)
    puts # just an empty line so result can be easy read able
    puts 'Test Case 5 "invalid_start_date" :- '
    @uri = URI(@invalid_start_date)
    response = Net::HTTP.get_response(@uri)
    invalid_start_date_response = JSON.parse(response.body)
    @should_get_400_code = response.code.to_i
    puts invalid_start_date_response['error'] == expected ? " Valid Responce:-  '#{expected}'" : "  'Wrong body responce, Getting #{invalid_start_date_response} it should be #{expected}"
    puts @should_get_400_code == status_code_should_be ? "  'Success' getting #{@should_get_400_code}" : "Failed Responce code is #{@result}"
  end

  def self.when_days_are_366(expected)
    puts # just an empty line so result can be easy read able
    puts 'Test Case 6 "When days are 366" :- '
    @uri = URI(@days_are_366)
    response = Net::HTTP.get_response(@uri)
    when_days_are_366_response = JSON.parse(response.body)
    puts when_days_are_366_response['totalCost'] == expected ? "  Valid Responce:-  '#{expected}' " : " 'Wrong body responce, Getting #{when_days_are_366_response} it should be '#{expected}' because we are allowed only up to 365 days"
  end
end

TestResponce.success(200)
TestResponce.check_missing_days('Must provide startDate and numberOfDays',400)
TestResponce.check_missing_date('Must provide startDate and numberOfDays',400)
TestResponce.invalid_days('Invalid numberOfDays', 400)
TestResponce.invalid_start_date('Invalid startDate', 400)
TestResponce.when_days_are_366('Invalid numberOfDays')
