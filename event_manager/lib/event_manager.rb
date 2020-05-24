require "csv"
require "google/apis/civicinfo_v2"
require "erb"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = "AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw"

  begin
    civic_info.representative_info_by_address(
      address: zip, 
      levels: "country", 
      roles: ["legislatorUpperBody", "legislatorLowerBody"]
      ).officials
  rescue
    "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"

  filename = "output/thanks_#{id}.html"

  File.open(filename, "w") do |file|
    file.puts form_letter
  end
end

def clearup_phone_number(homephone)
  #REGEX to filter all non digit numbers
  homephone.gsub!(/\D/, "")

  if homephone.length == 10
    homephone
  elsif homephone.length == 11 && homephone[0] == 1
    homephone[1..10]
  else
    "Bad Number!"
  end
end

#check this again
def check_signup_date(signup)
  date = DateTime.strptime(signup, "%m/%d/%Y %H:%M")
end

def count_registrations(registration_time)
  i = 0
  most_registrations = 0
  
  registration_time.each do |time|
    if i <= registration_time.count(time)
      i = registration_time.count(time)
      most_registrations = time
    end
  end
  return most_registrations
end

puts "EventManager initialized"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

#loading the template as string => para für erb template
template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter
registration_hour = Array.new
registration_day = Array.new


contents.each do |row|
  id = row[0]
  name = row[:first_name]

  homephone = clearup_phone_number(row[:homephone])

  date = check_signup_date(row[:regdate])

  registration_hour << date.hour

  registration_day << date.wday

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)
end

p count_registrations(registration_hour)
p count_registrations(registration_day)
p registration_day