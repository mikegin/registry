note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_DIVORCE
inherit
	ETF_DIVORCE_INTERFACE
		redefine divorce end
create
	make
feature -- command
	divorce(a_id1: INTEGER_64 ; a_id2: INTEGER_64)
		require else
			divorce_precond(a_id1, a_id2)
    	do
    		--check possible errors and append them to model out
    		if a_id1 = a_id2 then
    			model.set_message (err_msg_access.m.err_id_same)
    		elseif not model.check_id_positive (a_id1) or not model.check_id_positive (a_id2) then
    			model.set_message (err_msg_access.m.err_id_nonpositive)
    		elseif not model.persons.has (a_id1) or not model.persons.has (a_id2) then
				model.set_message (err_msg_access.m.err_id_unused)
			elseif model.married_to[a_id1] /= a_id2 then
				model.set_message (err_msg_access.m.err_divorce)
    		else
				model.set_message (err_msg_access.m.no_error)

				model.divorce (a_id1, a_id2)
    		end

    		etf_cmd_container.on_change.notify ([Current])

			--needed?
    		model.set_message("")
    	end

end
