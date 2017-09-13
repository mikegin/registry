note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MARRY
inherit
	ETF_MARRY_INTERFACE
		redefine marry end
create
	make
feature -- command
	marry(id1: INTEGER_64 ; id2: INTEGER_64 ; date: TUPLE[d: INTEGER_64; m: INTEGER_64; y: INTEGER_64])
		require else
			marry_precond(id1, id2, date)
    	local
    		date1: DATE
    	do
    		--check possible errors and append them to model out
    		if not model.is_valid_date (date) then
    			model.set_message (err_msg_access.m.err_invalid_date)
    		else
    			create date1.make (date.y.as_integer_32, date.m.as_integer_32, date.d.as_integer_32)
    			if id1 = id2 then
	    			model.set_message (err_msg_access.m.err_id_same)
	    		elseif not model.check_id_positive (id1) or not model.check_id_positive (id2) then
	    			model.set_message (err_msg_access.m.err_id_nonpositive)
	    		elseif not model.persons.has (id1) or not model.persons.has (id2) then
					model.set_message (err_msg_access.m.err_id_unused)
				elseif not model.valid_marriage (id1, id2, date1) then
					model.set_message (err_msg_access.m.err_mary)
	    		else
					model.set_message (err_msg_access.m.no_error)
					model.marry (id1, id2, date1)
	    		end
    		end


    		etf_cmd_container.on_change.notify ([Current])

			--needed?
    		model.set_message("")
    	end

end
