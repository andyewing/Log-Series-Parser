#Parses a series of the same logs with sub-sections into a csv
module LogSeriesParser
	require 'csv'

	#some constants: Section divider
	SECTION_DIVIDER = "---"

	#parse takes in entryregex, for identifyint the start of new log entries,
	#subregex, for any sub-sections of similar kind in each log entry
	#and parseregex, an array of all regex's of note
	def log_series_parse(entryregex, *subregex, *parseregex)
		
		
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
				paresout << temparr
				
				#Clear the temporary array
				temparr = []
				
				when *subregex
				
				#and add a section divider
				temparr << SECTION_DIVIDER
				
				when *parseregex
				
				#Add the results to the temporary array
				temparr << pull_parsed(line,*parseregex).values
				
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
