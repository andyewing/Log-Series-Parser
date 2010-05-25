=begin

This MatchData carries two Boolian instance variables:
@set = true if it denotes the beginning of a new set
@subsection == true if it denotes the beginning of a new subsection

It also has a String instance variable that is the replacement string
to be used.

=end

class LogMatchData < MatchData
	attr_accessor :set, :subsection, :replacement_string
	
	# I don't want to mess with the initialize method, but I need to get
	# the variables set somehow, and one line seems better than three.
	def set_log_variables(set,subsection,replacement_string)
		@set = set
		@subsection = subsection
		@replaement_string = replacement_string
	end
		


end

