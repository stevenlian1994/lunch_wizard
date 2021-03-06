require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

  puts @d = DateTime.now
  @year = @d.year
  @month = @d.month
  puts @day = @d.day
  





# require 'yelp'

# Yelp.client.configure do |config|
#   config.consumer_key = "3qFjFjxfKq8sR9sHRSXdWNrMpTewyxKqSBq1Otu2qlKdlbAHqMBGHYMgi2S7YYQ2lLaBFfDZhew_fFS4FgOJDQeaaLYKrDDxDwOjMzg56wIqKhAcjeLWmp63_f1tWnYx"
#   config.consumer_secret = YOUR_CONSUMER_SECRET
#   config.token = YOUR_TOKEN
#   config.token_secret = YOUR_TOKEN_SECRET
# end

# Yelp.client.search('San Francisco', { term: 'food' })
                          
#   GET https://api.yelp.com/v3/businesses/search

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'
CLIENT_SECRETS_PATH = 'client_secret.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "calendar-ruby-quickstart.yaml")
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(
    client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(
      base_url: OOB_URI)
    puts "Open the following URL in the browser and enter the " +
         "resulting code after authorization"
    puts url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI)
  end
  credentials
end

# Initialize the API
service = Google::Apis::CalendarV3::CalendarService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

calendar_id = 'primary'
response = service.list_events(calendar_id,
                              max_results: 10,
                              single_events: true,
                              order_by: 'startTime',
                              time_min: Time.now.iso8601,
                              time_max: (Time.now+(60*60*24)).iso8601
                              )


 
# puts response.class #=> Google::Apis::CalendarV3::Events
# puts response.items.class #=> Array
# puts response.items #<Google::Apis::CalendarV3::Event:0x00000002e690b8>
#<Google::Apis::CalendarV3::Event:0x00000002dfd4f8>
#<Google::Apis::CalendarV3::Event:0x00000002d444f8>
@lunch_boolean = false
puts "Checking the events for the next 24 hours..."
response.items.each do |event|
    # puts event #=> #<Google::Apis::CalendarV3::Event:0x000000016000a8>
    if event.summary.include?('lunch') || event.summary.include?('Lunch')
        @lunch_boolean = true 
        #if lunch is planned, give me a summary
        event_array = [event.summary, event.location, event.start.date_time.strftime]
        
        puts "Lunch is already planned for today.."
        
        event_array.each do |var|
            if var != nil
                var
            end
        end

    end
end

@before_checker = 0
@after_checker = 0
  response.items.each do |event|
    a = 12
    event_array = [event.summary, event.location, event.start.date_time.strftime]
    b = event.start.date_time.hour-12
    event_array << b
    print event_array
    puts
    if @before_checker == 0
      @before_checker = event_array.last
    elsif @before_checker < event_array.last
      @before_checker = event_array.last
    end
    puts @before_checker
    
  
    # if event_array.last 
  #HAVING TROUBLE PUTTING RESPONSE IN A METHOD .. find_event_before_lunch': undefined local variable or method `response' for main:Object (NameError)

def create_lunch_event(lunch_date,service)
  

  if lunch_date == "today"
    next_lunch_start = DateTime.new(@year,@month,@day,11,0,0,'-8')
    next_lunch_end = DateTime.new(@year,@month,@day,13,0,0,'-8')
  else
    next_lunch_start = DateTime.new(@year,@month,@day+1,11,0,0,'-8')
    next_lunch_end = DateTime.new(@year,@month,@day+1,13,0,0,'-8')
  end
        	
  event = Google::Apis::CalendarV3::Event.new({
    summary: 'API Created Lunch',
    location: '1615 S. Diamond Bar BLVD, Diamond Bar, CA 91765',
    description: 'lunch at home.',
    start: {
      date_time: next_lunch_start,
      time_zone: 'America/Los_Angeles',
    },
    end: {
      date_time: next_lunch_end,
      time_zone: 'America/Los_Angeles',
    }
  })
            
    result = service.insert_event('primary', event)
    puts "Event created: #{result.html_link}"
  
end

def location_pinpoint(location_before,location_after)
  

end

puts "lunch boolean is: " + @lunch_boolean.to_s






if @lunch_boolean == false
    puts "Do you want to order lunch?"
    client_response = gets.chomp
    #set 1 or 2 known locations around lunch as location_before and location_after, and assign them as arguments to location_pinpoint method
    
    
    if client_response == "yes"
        if @d.hour <= 14 
          create_lunch_event("today",service)
	
        else
        	create_lunch_event("tomorrow",service)
        	
        end
    else
        puts "Okay, no lunch ordered"
    end
end



    








# # Fetch the next 10 events for the user

# calendar_id = 'primary'
# response = service.list_events(calendar_id,
#                               max_results: 10,
#                               single_events: true,
#                               order_by: 'startTime',
#                               time_min: Time.now.iso8601)

# puts "Upcoming events:"
# puts "No upcoming events found" if response.items.empty?
# response.items.each do |event|
#   start = event.start.date || event.start.date_time
#   finish = event.end.date || event.end.date_time
#   puts "- #{event.summary} : (#{start}) - (#{finish})"
# end



#         	event = Google::Apis::CalendarV3::Event.new({
#               summary: 'API Created Lunch',
#               location: '1615 S. Diamond Bar BLVD, Diamond Bar, CA 91765',
#               description: 'lunch at home.',
#               start: {
#                 date_time: '2018-02-09T11:00:00-08:00',
#                 time_zone: 'America/Los_Angeles',
#               },
#               end: {
#                 date_time: '2018-02-09T13:00:00-08:00',
#                 time_zone: 'America/Los_Angeles',
#               }
#             })
            
            


# result = service.insert_event('primary', event)
# puts "Event created: #{result.html_link}"