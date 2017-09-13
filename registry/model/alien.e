note
	description: "Summary description for {ALIEN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ALIEN

inherit
	PERSON

create
	make

feature {NONE} -- Initialization

	make(id1: INTEGER_64; name1: STRING; dob1: DATE; country: STRING)
			-- Initialization for `Current'.
		do
			id := id1
			name := name1
			dob := dob1
			citizenship := country
			status := "Single"
		end

end
