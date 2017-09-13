note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_DIE
inherit
	ETF_DIE_INTERFACE
		redefine die end
create
	make
feature -- command
	die(id: INTEGER_64)
		require else
			die_precond(id)
    	local
    		dob1: DATE
    	do
    		--check possible errors and append them to model out
    		if not model.check_id_positive (id) then
    			model.set_message (err_msg_access.m.err_id_nonpositive)
    		elseif not model.persons.has (id) then
    			model.set_message (err_msg_access.m.err_id_unused)
    		elseif model.is_dead (id) then
    			model.set_message (err_msg_access.m.err_dead_already)
    		else
				model.set_message (err_msg_access.m.no_error)

				model.die (id)
    		end

    		etf_cmd_container.on_change.notify ([Current])

			--needed?
    		model.set_message("")
    	end

end
