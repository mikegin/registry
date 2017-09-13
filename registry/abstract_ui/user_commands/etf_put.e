note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PUT
inherit
	ETF_PUT_INTERFACE
		redefine put end
create
	make
feature -- command
	put(id: INTEGER_64 ; name1: STRING ; dob: TUPLE[d: INTEGER_64; m: INTEGER_64; y: INTEGER_64])
		require else
			put_precond(id, name1, dob)
    	local
    		dob1: DATE
    	do
    		--check possible errors and append them to model out
    		if not model.check_id_positive (id) then
    			model.set_message (err_msg_access.m.err_id_nonpositive)
    		elseif model.persons.has (id) then
    			model.set_message (err_msg_access.m.err_id_taken)
    		elseif name1.is_empty or (not name1.is_empty and then not name1.item (1).is_alpha) then
    			model.set_message (err_msg_access.m.err_name_start)
    		elseif not model.is_valid_date (dob) then
				model.set_message (err_msg_access.m.err_invalid_date)
    		else
				model.set_message (err_msg_access.m.no_error)

				create dob1.make (dob.y.as_integer_32, dob.m.as_integer_32, dob.d.as_integer_32)

				model.put (id, name1, dob1)
    		end

    		etf_cmd_container.on_change.notify ([Current])

			--needed?
    		model.set_message("")
    	end

end
