note
	description: "Type of person who is a citizen of Canada"
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

class
	CITIZEN

inherit
	PERSON

create
	make

feature {NONE} -- Initialization

	make(id1: INTEGER_64; name1: STRING; dob1: DATE)
			-- Initialization for `Current'.
		do
			id := id1
			name := name1
			dob := dob1
			citizenship := "Canada"
			status := "Single"
		end

end
