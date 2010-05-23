# entry regex
logstart = /====================================/

#section regex's
vsmem = /"MemoryAlloPercent">\d+/
interface = /(?<Interface Name>\S+).*Link encap:Ethernet.*/

#parsing regex's
time = /(?<time>.*GMT-06:00 2010)/
memused = /\"MemoryUsedPercent\">(?<Memory Used>\d+)/
procload = /\"Processing Load Percentage\">(?<Processor Load>\d+)/
gear = /\"Current backlog Actions\">(?<Gear>\d+)/
receive = /\s*RX packets:(?<packets>\d+) errors:(?<errors>\d+) dropped:(?<dropped>\d+) overruns:(?<overruns>\d+)/
rxbytes = /\s*RX bytes:(?<RX bytes>\d+)/

module LogSeriesParser
require 'csv'

#some constants: Section divider
SECTION_DIVIDER = "---"

#parse takes in entryregex, for identifyint the start of new log entries,
#subregex, for any sub-sections of similar kind in each log entry
#and parseregex, an array of all regex's of note
def log_series_parse(entryregex, subregex1, subregex2, *parseregex)

#combine subregex
subregex = [subregex1,subregex2]

#First we initialize the array
temparr = []

#And we open the output file
#!! Throw--Catch this...
parseout = CSV.new("#{self.to_path}.csv")

#For each line in the IO stream
self.each_line do |line|

#Match the appropriate regex
case line

# When it's the start of a new log entry
when entryregex

#Send the current temporary array contents to the CSV file
parseout << temparr

#Clear the temporary array
temparr = []

when *subregex

#and add a section divider
temparr << SECTION_DIVIDER

when *parseregex

#Add the results to the temporary array
tempvalues = pull_parsed(line,*parseregex).values
temparr << tempvalues.flatten

else 
#do nothing
end
end

#Then we close out the new csv
parseout.close

end

protected

def pull_parsed(line,*parseregex)


#Find out which match matched
parseregex.each do |reg|

if a = line.match(reg)

#make a temporary hash variable
h = {}

#collect the keys and values
a.names.each_with_index do |name, idx|
h["name"] = a[idx]
end

#and return the hash
return h
end

end

puts "match didn't match..."

end


end


class File
include LogSeriesParser
end

file_to_parse = File.open('cid-short.txt')

file_to_parse.log_series_parse(logstart,vsmem,interface,time,memused,procload,gear,receive,rxbytes)