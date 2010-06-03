filename = ARGV[0]

#Require LogSeriesParser
require 'log_series_file.rb'

#Require CSV as output format
require 'csv'

blank = MatchProperties.new

#This set is for Virtual Sensor Overall Statistics


# entry regex
logstart = LogRegexp.new(MatchProperties.new(MatchType::SET,""),/===================================/)

#section regex's
vsmem = LogRegexp.new(MatchProperties.new(MatchType::SUBSECTION,"memallopercent"),/\"MemoryAlloPercent\">(?<memallopercent>\d+)/)
interface = LogRegexp.new(MatchProperties.new(MatchType::SUBSECTION,""),/(?<Interface Name>\S+).*Link encap:Ethernet.*/)

#parsing regex's
time = LogRegexp.new(blank,/(?<time>.*GMT-06:00 2010)/)
memused = LogRegexp.new(blank,/\"MemoryUsedPercent\">(?<Memory Used>\d+)/)
procload = LogRegexp.new(blank,/\"Processing Load Percentage\">(?<Processor Load>\d+)/)
gear = LogRegexp.new(blank,/\"Current backlog Actions\">(?<Gear>\d+)/)
receive = LogRegexp.new(blank,/\s*RX packets:(?<packets>\d+) errors:(?<errors>\d+) dropped:(?<dropped>\d+) overruns:(?<overruns>\d+)/)
rxbytes = LogRegexp.new(blank,/\s*RX bytes:(?<RX bytes>\d+)/)




file_to_parse = LogSeriesFile.open(filename)

file_to_parse.log_series_parse(logstart,vsmem,interface,time,memused,procload,gear,receive,rxbytes)