=begin

This MatchData carries two Boolian instance variables:
@set = true if it denotes the beginning of a new set
@subsection == true if it denotes the beginning of a new subsection

It also has a String instance variable that is the replacement string
to be used.

=end

class LogMatchData < MatchData
	attr_accessor :set, :subsection, :replacement_string
	
	def initialize(set,subsection,replacement_string,*args)
		@set = set
		@subsection = subsection
		@replaement_string = replacement_string
		super(*args)
	end
		


end

