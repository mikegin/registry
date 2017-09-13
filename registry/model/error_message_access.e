note
	description: "Singleton acces to the class containing error messages."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	ERROR_MESSAGE_ACCESS

feature
	m: ERROR_MESSAGE
		once
			create Result.make
		end

invariant
	m = m
end
