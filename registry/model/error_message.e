note
	description: "Class that contains the possible error message for input"
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

class
	ERROR_MESSAGE

create{ERROR_MESSAGE_ACCESS}
	make

feature{NONE} -- Initialization
	make
		do

		end

feature -- list of error messages
	err_id_nonpositive: STRING = "id must be positive"
	err_id_unused: STRING = "id not identified with a person in database"
	err_id_same: STRING = "ids must be different"
	err_id_taken: STRING = "id already taken"
	err_name_start: STRING = "name must start with A-Z or a-z"
	err_country_start: STRING = "country must start with A-Z or a-z"
	err_invalid_date: STRING = "not a valid date in 1900..3000"
	err_mary: STRING = "proposed marriage invalid"
	err_divorce: STRING = "these are not married"
	err_dead_already: STRING = "person with that id already dead"
	no_error: STRING = "ok"

end
