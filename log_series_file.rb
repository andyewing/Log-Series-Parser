# == Synopsis 
#   A LogSeriesFile is an extension of the file class that can parse itself,
#	given certain inputs
#
# == Examples
#   
#	a_f = LogRegexp.new(blank,/Alerts received = (?<Alerts Fired>\d+)/)
#	file_to_parse = LogSeriesFile.open(filename)
#	file_to_parse.log_series_parse(a_f)
#   
#	This will create a csv with the name filename.csv that has a column 
#	of TCP Tracked per sec
#
# == Usage 
#   1) Create some LogRegexp to match
#	2) Open the file to be parsed as a LogSeriresFile
#	3) call the log_series_parse method on the file, with LogRegexps as args
#
# == Options
#   TO DO - add additional options
#
# == Author
#   Andy Ewing
#
# == Copyright
#   Copyright (c) 2010 Andy Ewing. Licensed under the MIT License:
#   http://www.opensource.org/licenses/mit-license.php

#Require LogRegexp and LogMatchData
require 'log_regexp.rb'
require 'match_properties.rb'

#Require CSV as output format
require 'csv'

#Parses a series of the same logs with sub-sections into a csv
class LogSeriesFile < File

	#some constants: Section divider and debug flag
	SECTION_DIVIDER = "---"
	DEBUG = true
	
	# Instance Variables
	attr_accessor :outfile, :data_arr, :header_arr, :gathering_state
	
	#parse takes in entryregex, for identifyint the start of new log entries,
	#subregex, for any sub-sections of similar kind in each log entry
	#and parseregex, an array of all regex's of note
	def log_series_parse(*log_regexes)
		
		#And we open the output file
		#!! Throw--Catch this...
		@outfile = CSV.open("#{self.path}.csv",'wb')
		
		#A temporary array for the data
		@data_arr = []
		
		#A temporary array for the headers, and a variable to track state
		@header_arr = []
		@gathering_state = 0
		
	
		#For each line in the IO stream
		self.each_line do |line|
		
			#Compare it to each regular expression
			log_regexes.each do |lr|
				
				# If it matches,
				if m = line.match(lr)
					
					# Call the decision engine
					self.decision_engine(m,lr)

				end # If it matches...
				
				#no constraint on not matching
				
			end #Compare it to each regular expression
		
		
		end #For each line in the IO stream
		
		#Send any remaining temp array to the csv
		@outfile << @data_arr
		
		#Add the header row
		@outfile << @header_arr
		
		#Then we close out the new csv
		@outfile.close
		
	end
	
	
	protected
	
	def decision_engine(m,lr)
	
		#Find out if it's a set, subsection, or none
		case lr.type
		
		#When it's a set delimiter, 
		when MatchType::SET
		
			#If it has a replacement string
			if !lr.replacement_string.empty?
				#send the temporary array to the csv
				@outfile << @data_arr
			
				#reset the temporary array to the replacement str
				@data_arr = [m[lr.replacement_string.to_sym]]

			else
				
				#send the temporary array to the csv
				@outfile << @data_arr
			
				#reset the temporary array
				@data_arr = []							
			end
			
			#Header Gathering Subsection:
			case @gathering_state 
			
			when 0 # Just starting out, hit first set
			
				#Set State to gathering
				@gathering_state = 1
			
			when 1 # Gathering headers and hit next set
				
				#Set state to stopped
				@gathering_state = 2
			
			end
		
		#When it's a SUBSECTION delimiter, 
		when MatchType::SUBSECTION
		
			#If it has a replacement string
			if !lr.replacement_string.empty?
			
				#add a spacer and the replacement string to @data_arr
				@data_arr.concat(["",m[lr.replacement_string.to_sym]])
				
				
			else
				
				#add a spacer
				@data_arr << ""
				
			end

			#Header Gathering Subsection:
			
			#If in gathering state
			if @gathering_state == 1 then
			
				#add a spacer and the capture name
				@header_arr.concat(["",lr.names].flatten)
			
			end
			
		#When it's just a match, 
		when MatchType::NONE
			
			#Add the contents of the match to the temporary array
			@data_arr.concat(m.captures)
			
			#If in gathering state
			if @gathering_state == 1 then
			
				#add a spacer and the capture name
				@header_arr.concat(lr.names)
			
			end
		
		#When the type is not set, or is none of the above
		else
			puts "LogRegexp has an invalid type"
		end
	
	end
	
	def debugout(thing)
	
	@debugtxt << thing.to_s + "\n"
	
	end
	
	
end
