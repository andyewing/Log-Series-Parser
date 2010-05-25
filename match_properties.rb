=begin

This class carries two Boolian instance variables:
@set = true if it denotes the beginning of a new set
@subsection == true if it denotes the beginning of a new subsection

It also has a String instance variable that is the replacement string
to be used.

=end

class MatchProperties
	attr_accessor :match_type, :replacement_string
	
	def initialize(type=MatchType::NONE,replacement_string="")
		@match_type = type
		@replacement_string = replacement_string
	end
	
end

class MatchType
	SET = 1
	SUBSECTION = 2
	NONE = 3
end

