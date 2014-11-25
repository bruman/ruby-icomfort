#!/usr/bin/env ruby

require 'rest_client'
require 'json'
require 'uri'
require 'pp'


if ARGV.length != 2
    abort "icomfort2 <username> <password>\n"
end


#RestClient.proxy = "http://localhost:8008"
username=ARGV[0]
password=ARGV[1]


p "#{username}"


response1 = RestClient.put "https://#{username}:#{password}@services.myicomfort.com/DBAcessService.svc/ValidateUser?UserName=#{username}&lang_nbr=0",'', :content_type => 'application/json'
response1.cookies
# => {"_applicatioN_session_id" => "1234"}
p response1

response2 = RestClient.get "https://#{username}:#{password}@services.myicomfort.com/DBAcessService.svc/GetBuildingsInfo?UserId=#{username}"
p "DBAcessService.svc/GetBuildingsInfo"
pp response2

response3 = RestClient.get "https://#{username}:#{password}@services.myicomfort.com/DBAcessService.svc/GetSystemsInfo?UserId=#{username}"
p "DBAcessService.svc/GetSystemsInfo"
pp response3


json_object = JSON.parse(response3)
json_object["Systems"].each do |system|
   p "Gateway_SN"
   p system["Gateway_SN"]
   p "DBAcessService.svc/GetTStatLookupInfo"
   response4 = RestClient.get "https://#{username}:#{password}@services.myicomfort.com//DBAcessService.svc/GetTStatLookupInfo?gatewaysn=#{system["Gateway_SN"]}&name=all"
   json_object4 = JSON.parse(response4)
   pp json_object4
   
   p "DBAcessService.svc/GetTStatInfoList"
   response5 = RestClient.get "https://#{username}:#{password}@services.myicomfort.com/DBAcessService.svc/GetTStatInfoList?GatewaySN=#{system["Gateway_SN"]}&TempUnit=&Cancel_Away=-1"
   json_object5 = JSON.parse(response5)
   pp json_object5

   response6 = RestClient.get "https://#{username}:#{password}@services.myicomfort.com/DBAcessService.svc/GetGatewayInfo?GatewaySN=#{system["Gateway_SN"]}&TempUnit=0"
   json_object6 = JSON.parse(response6)
   p "DBAcessService.svc/GetGatewayInfo"
   pp json_object6
 
   response7 = RestClient.get "https://#{username}:#{password}@services.myicomfort.com//DBAcessService.svc/GetTStatScheduleInfo?gatewaysn=#{system["Gateway_SN"]}"
   json_object7 = JSON.parse(response7)
   p "DBAcessService.svc/GetTStatScheduleInfo"
   pp json_object7

   response8 = RestClient.get "https://#{username}:#{password}@services.myicomfort.com//DBAcessService.svc/GetGatewaysAlerts?gatewaysn=#{system["Gateway_SN"]}"
   json_object8 = JSON.parse(response8)
   p "DBAcessService.svc/GetGatewaysAlerts"
   pp json_object8

  #set temp
#{
#  "Away_Mode": "0",
#  "Central_Zoned_Away": "2",
#  "ConnectionStatus": "GOOD",
#  "DateTime_Mark": "/Date(1415523801077+0000)/",
#  "Fan_Mode": "0",
#  "GatewaySN": "XXXXXXXX",
#  "Indoor_Humidity": "43",
#  "Indoor_Temp": 68,
#  "Operation_Mode": "3",
#  "Pref_Temp_Units": "0",
#  "Program_Schedule_Mode": "1",
#  "Program_Schedule_Selection": "1",
#  "Zone_Enabled": "1",
#  "Zone_Name": "Zone 1",
#  "Zone_Number": "0",
#  "Zones_Installed": "1",
#  "Cool_Set_Point": 80.0,
#  "coolSetPoint1": 78.0,
#  "Heat_Set_Point": 67.0,
#  "heatSetPoint1": 70.0,
#  "programCoolPoint": 0.0,
#  "programHeatPoint": 0.0,
#  "isAwayPanelShown": false,
#  "System_Status": 0
#}

  #Change "Heat_Set_Point":68.0 or "Cool_Set_Point":80.0
  #respone9 = RestClient.put "https://#{username}:#{password}@services.myicomfort.com//DBAcessService.svc/SetTStatInfo",#{json},:content_type => 'application/json'
  #json_object9 = JSON.parse(response9)
  #pp json_object9

  #get /DBAcessService.svc/GetProgramInfo?GatewaySN=XXXXXXXX&SchenuleNum=15&TempUnit=0
  #{
  #"Cool_Set_Point": 85.00,
  #"Fan_Mode": 0,
  #"GatewaySN": "XXXXXXXX",
  #"Heat_Set_Point": 62.00,
  #"ReturnStatus": "SUCCESS",
  #"ScheduleNum": 15
  #}
  #put /DBAcessService.svc/SetAwayModeNew?gatewaysn=XXXXXXXX&zonenumber=0&awaymode=1&heatsetpoint=62.000000&coolsetpoint=85.000000&fanmode=0&tempscale=-1  
  
  #PUT /DBAcessService.svc/SetAwayModeNew?gatewaysn=XXXXXXXX&zonenumber=0&awaymode=0&heatsetpoint=62.000000&coolsetpoint=85.000000&fanmode=0&tempscale=-1

  #GET /DBAcessService.svc/GetProgramInfo?GatewaySN=XXXXXXXX&Sc
  
  #PUT /DBAcessService.svc/SetProgramInfoNew

  #{
  #"Fan_Mode": "2",
  #"GatewaySN": "XXXXXXXX",
  #"Operation_Mode": "3",
  #"Pref_Temp_Units": "0",
  #"Program_Schedule_Mode": "1",
  #"Program_Schedule_Selection": "2",
  #"ReturnStatus": "SUCCESS",
  #"Zone_Number": "0",
  #"Cool_Set_Point": 80.0,
  #"Heat_Set_Point": 50.0
  ##}

  #GET /DBAcessService.svc/GetAboutLennox
  #GET /DBAcessService.svc/GetBuildingsInfo?UserId=#{username}
  #GET /DBAcessService.svc/GetSystemsInfo?UserId=#{username}


  while 1 do
    response9 = RestClient.get "https://#{username}:#{password}@services.myicomfort.com//DBAcessService.svc/GetTStatInfoList?GatewaySN=#{system["Gateway_SN"]}&TempUnit=&Cancel_Away=-1"
    json_object9 = JSON.parse(response9)
    pp json_object9
    
    json_object9['tStatInfo'].each do |tstat|
     system_status = json_object4['tStatlookupInfo'].select {|h1| h1['name']=='System_status'}.select {|h2| h2['value']==tstat['System_Status']}.first['description']

     fan_mode = json_object4['tStatlookupInfo'].select {|h1| h1['name']=='Fan_mode'}.select {|h2| h2['value']==tstat['Fan_Mode']}.first['description']

     operation_mode = json_object4['tStatlookupInfo'].select {|h1| h1['name']=='Operation_mode'}.select {|h2| h2['value']==tstat['Operation_Mode']}.first['description']

     p "date, Cool_Set_Point, Head_Set_Point, Indoor_temp, Fan_Mode, Indoor_Humidity, System_Status, Operation_Mode"
     p "#{tstat['DateTime_Mark']},#{tstat['Cool_Set_Point']},#{tstat['Heat_Set_Point']},#{tstat['Indoor_Temp']},#{fan_mode},#{tstat['Indoor_Humidity']},#{system_status},#{operation_mode}"
    end  
    sleep 1
  end
end

#get Temparture Range
#response3 = RestClient.get "https://services.myicomfort.com/DBAcessService.svc/GetTemperatureRange?lowpoint=-48&highpoint=48"

#get App information
#response3 = RestClient.get "https://services.myicomfort.com//DBAcessService.svc/GetApplicationParam?AWAY_MODE=all"
