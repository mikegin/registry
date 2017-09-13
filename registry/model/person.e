note
	description: "Person class representing a person in the Passport Canada registry"
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PERSON

inherit
	COMPARABLE
	redefine
		is_less, out
	end

feature{NONE} -- Implementation
	name: STRING
	dob: DATE
	citizenship: STRING
	id: INTEGER_64
	status: STRING

feature -- commands
	set_status(status1: STRING)
		do
			status := status1
		end

	set_married_to(p: PERSON; date: DATE)
		local
			day: STRING
			month: STRING
		do
			-- attach leading zero's
			day := date.day.out
			if date.day < 10 then
				day.prepend ("0")
			end
			month := date.month.out
			if date.month < 10 then
				month.prepend ("0")
			end
			status := "Spouse: " + p.get_name + "," + p.get_id.out + "," + "[" + date.year.out + "-" + month + "-" + day + "]"
		end

feature -- queries
	get_name: STRING
		do
			Result := name
		end

	get_dob: DATE
		do
			Result := dob
		end

	get_citizenship: STRING
		do
			Result := citizenship
		end

	get_id: INTEGER_64
		do
			Result := id
		end

	get_status: STRING
		do
			Result := status
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if  name < other.get_name then
				Result := true
			elseif name ~ other.get_name and id < other.get_id then
				Result := true
			else
				Result := false
			end
		ensure then
			Result = (name < other.get_name) or else (name ~ other.get_name and id < other.get_id)
		end

	out: STRING
		local
			day: STRING
			month: STRING
		do
			create Result.make_empty
			Result.append(name + "; " )
			Result.append("ID: " + id.out + "; ")

			-- attach leading zero's
			day := dob.day.out
			if dob.day < 10 then
				day.prepend ("0")
			end
			month := dob.month.out
			if dob.month < 10 then
				month.prepend ("0")
			end

			Result.append("Born: " + dob.year.out + "-" + month + "-" + day + "; ")
			Result.append("Citizen: " + citizenship + "; ")
			Result.append (status)
		end
end
