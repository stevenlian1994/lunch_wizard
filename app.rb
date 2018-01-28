require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'
CLIENT_SECRETS_PATH = 'client_secret.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "calendar-ruby-quickstart.yaml")
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

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

response.items.each do |event|
    if event.summary.include?('lunch') || event.summary.include?('Lunch')
        @lunch_boolean = true 
    end
end

puts @lunch_boolean

if @lunch_boolean == false
    puts "Would you like to plan for lunch?"
    user_input = gets.chomp
    if user_input == "yes"
        puts "function for planning lunch"
    else
        puts "Okay, but don't starve yourself"
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



