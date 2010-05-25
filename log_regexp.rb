=begin

This regular expression carries two Boolian instance variables:
@set = true if it denotes the beginning of a new set
@subsection == true if it denotes the beginning of a new subsection

It also has a String instance variable that is the replacement string
to be used.

=end

require 'match_properties.rb'

class LogRegexp < Regexp
	attr_accessor :match_props
	
	def initialize(match_props,*args)
		@match_props = match_props
		super(*args)
	end
	
	def type
		return @match_props.match_type
	end
	
	def replacement_string
		return @match_props.replacement_string
	end


end

