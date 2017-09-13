note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	REGISTRY

inherit
	ANY
		redefine
			out
		end

create {REGISTRY_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create persons.make(10)
			persons.compare_objects

			create persons_sorted_list.make
			persons_sorted_list.compare_objects

			create married_to.make(10)
			married_to.compare_objects

			create message.make_from_string (err_msg_access.m.no_error)
		end

feature -- model attributes
	persons: HASH_TABLE[PERSON, INTEGER_64]
	persons_sorted_list: SORTED_TWO_WAY_LIST[PERSON]
	married_to: HASH_TABLE[INTEGER_64, INTEGER_64]
	message: STRING
	err_msg_access: ERROR_MESSAGE_ACCESS

feature -- model operations

	reset
			-- Reset model state.
		do
			make
		end

	set_message(msg: STRING)
		do
			message := msg
		end

	put(id: INTEGER_64; name: STRING; dob: DATE)
		require
			positive_id: check_id_positive(id)
			id_not_take: not persons.has (id)
			valid_name: not name.is_empty and then name.item (1).is_alpha
			valid_date: is_valid_date2(dob)
		local
			peep: PERSON
		do
			create {CITIZEN}peep.make (id, name, dob)
			persons.put (peep, id)
			persons_sorted_list.extend (peep)
			married_to.put (id, id) -- being single representation

		ensure
			registered: attached persons[id] as p and then (p.get_name ~ name and p.get_citizenship ~ "Canada" and p.get_dob ~ dob and p.get_id = id and p.get_status ~ "Single")
			increased_person_count: persons.count = old persons.count + 1
			others_unchanged_in_table: persons_unchanged_other_than(id, old persons.deep_twin) --everything in persons stays same except new person
			increased_person_sorted_list_count: persons_sorted_list.count = old persons_sorted_list.count + 1
			others_unchanged_in_list: persons_sorted_list_unchanged_other_than(id, old persons_sorted_list.deep_twin)
			increased_married_to_count: married_to.count = old married_to.count + 1
		end

	put_alien(id: INTEGER_64; name: STRING; dob: DATE; country: STRING)
		require
			positive_id: check_id_positive(id)
			id_not_take: not persons.has (id)
			valid_name: not name.is_empty and then name.item (1).is_alpha
			valid_date: is_valid_date2(dob)
			valid_country: not country.is_empty and then country.item (1).is_alpha
		local
			peep: PERSON
		do
			create {ALIEN}peep.make (id, name, dob, country)
			persons.put (peep, id)
			persons_sorted_list.extend (peep)
			married_to.put (id, id) -- being single representation

		ensure
			registered: attached persons[id] as p and then (p.get_name ~ name and p.get_citizenship ~ country and p.get_dob ~ dob and p.get_id = id and p.get_status ~ "Single")
			increased_person_count: persons.count = old persons.count + 1
			others_unchanged_in_table: persons_unchanged_other_than(id, old persons.deep_twin) --everything in persons stays same except new person
			increased_person_sorted_list_count: persons_sorted_list.count = old persons_sorted_list.count + 1
			others_unchanged_in_list: persons_sorted_list_unchanged_other_than(id, old persons_sorted_list.deep_twin)
			increased_married_to_count: married_to.count = old married_to.count + 1
		end

	marry(id1: INTEGER_64; id2: INTEGER_64; date: DATE)
		require
			different_ids: id1 /= id2
			positive_ids: check_id_positive(id1) and check_id_positive(id2)
			valid_date: is_valid_date2(date)
			persons_exist: persons.has (id1) and persons.has (id2)
			valid_marriage: valid_marriage(id1, id2, date)
		do
			if attached persons[id1] as p1 and attached persons[id2] as p2 then
				p1.set_married_to (p2, date)
				p2.set_married_to (p1, date)

				married_to.replace (id1, id2)
				married_to.replace (id2, id1)
			end
		ensure
			are_married: married_to[id1] = id2 and married_to[id2] = id1
			correct_status:
				(attached persons[id1] as p1 and attached persons[id2] as p2) and then
					(p1.get_status /~ "Single" and p1.get_status /~ "Deceased"
					and
					p2.get_status /~ "Single" and p2.get_status /~ "Deceased")
		end

	divorce(id1: INTEGER_64; id2: INTEGER_64)
		require
			different_ids: id1 /= id2
			positive_ids: check_id_positive(id1) and check_id_positive(id2)
			persons_exist: persons.has (id1) and persons.has (id2)
			persons_are_married: married_to[id1] = id2
		do
			if attached persons[id1] as p1 and attached persons[id2] as p2 then
				p1.set_status("Single")
				p2.set_status("Single")

				married_to.replace (id1, id1)
				married_to.replace (id2, id2)
			end
		ensure
			are_divorced: married_to[id1] = id1 and married_to[id2] = id2
			correct_status:
				(attached persons[id1] as p1 and attached persons[id2] as p2) and then
					(p1.get_status ~ "Single" and p2.get_status ~ "Single")
		end

	die(id: INTEGER_64)
		require
			positive_id: check_id_positive(id)
			person_exists: persons.has (id)
			not_dead: not is_dead(id)
		local
			has_spouse: BOOLEAN
			spouse_id: INTEGER_64
		do
			if attached persons[id] as p then -- needed due to void safety
				if not (p.get_status ~ "Single") then -- is married, make spose single
					spouse_id := married_to[id]

					married_to.replace (spouse_id, spouse_id)
					married_to.replace (id, id) -- being dead representation

					if attached persons[spouse_id] as e then --needed due to void safety
						e.set_status ("Single")
					end
				end
				p.set_status ("Deceased")
			end

		ensure
			person_count_unchanged: persons.count = old persons.count
			persons_sorted_list_count_unchanged: persons_sorted_list.count = old persons_sorted_list.count
			others_unchanged_in_table: persons_unchanged_other_than(id, old persons.deep_twin)
			others_unchanged_in_list: persons_sorted_list_unchanged_other_than(id, old persons_sorted_list.deep_twin)
			person_is_dead: is_dead(id)
			spouse_is_single_xor_self_is_dead:
				attached persons[old married_to[id]] as s and then -- spouse
					(s.get_status ~ "Single" -- if spouse was other person
						xor
						s.get_status ~ "Deceased") -- if spouse was self
		end


feature -- queries
	persons_unchanged_other_than (id: INTEGER_64; old_persons: like persons): BOOLEAN
			-- Are persons other than `person[id]' unchanged?
		local
			key: INTEGER_64
		do
			from
				Result := true
				persons.start
			until
				persons.after or not Result
			loop
				key := persons.key_for_iteration
				if key /= id then
					Result := old_persons[key] ~ persons[key]
				end
				persons.forth
			end
		ensure
			Result =
				across
					persons as p
				all
					p.key /= id IMPLIES
						old_persons[p.key] ~ persons[p.key]
				end
		end

	persons_sorted_list_unchanged_other_than (id: INTEGER_64; old_persons_sorted_list: like persons_sorted_list): BOOLEAN
		-- Are persons_sorted_list unchanged other than the the addition of `persons[id]'?
		do
			from
				Result := true
				persons_sorted_list.start
			until
				persons_sorted_list.after or not Result
			loop
				if persons_sorted_list.item.get_id /= id then
					Result := old_persons_sorted_list.has (persons_sorted_list.item)
				end
				persons_sorted_list.forth
			end
		ensure
			Result =
				across
					persons_sorted_list as p
				all
					p.item.get_id /= id IMPLIES
						old_persons_sorted_list.has (p.item)
				end
		end

	check_id_positive(id: INTEGER_64): BOOLEAN
		do
			if id > 0 then
				Result := True
			end
		end

	is_valid_date(dobAsTuple: TUPLE[d: INTEGER_64; m: INTEGER_64; y: INTEGER_64]): BOOLEAN
		local
			is_valid_date_object: DATE
		do
			create is_valid_date_object.make_now
			Result := (dobAsTuple.y >= 1900 and dobAsTuple.y <= 3000) and then is_valid_date_object.is_correct_date (dobAsTuple.y.as_integer_32, dobAsTuple.m.as_integer_32, dobAsTuple.d.as_integer_32)
		end

	is_valid_date2(dob: DATE): BOOLEAN
		do
			Result := dob.year >= 1900 and dob.year <= 3000
		end

	is_dead(id: INTEGER_64): BOOLEAN
		do
			if attached persons[id] as p and then (p.get_status ~ "Deceased") then
				Result := True
			end
		end

	valid_marriage(id1: INTEGER_64; id2: INTEGER_64; m_date: DATE): BOOLEAN
		local
			m_date1: DATE
			min_dob: DATE
		do
			create m_date1.make (m_date.year, m_date.month, m_date.day)
			if m_date1.is_leap_year (m_date1.year) then
				if m_date1.day = 29 and m_date1.month = 2 then
					m_date1.set_day (28)
				end
			end
			create min_dob.make (m_date1.year - 18, m_date1.month, m_date1.day)
			if (attached persons[id1] as p1 and attached persons[id2] as p2) and then
				(p1.get_status ~ "Single" and p2.get_status ~ "Single" and p1.get_dob <= min_dob and p2.get_dob <= min_dob) then
					Result := True
			end
		end




	out : STRING
		local
			p: PERSON
		do
			create Result.make_from_string ("  ")
			Result.append (message)
			from
				persons_sorted_list.start
			until
				persons_sorted_list.after
			loop
				Result.append("%N")
				Result.append ("  ")
				Result.append(persons_sorted_list.item.out)
				persons_sorted_list.forth
			end
			--
--			Result.append ("%N")
--			across
--			married_to as l
--			loop
--				Result.append (l.key.out + " -> " + married_to[l.key].out + "%N")
--			end
			--
		end

invariant
	list_coincides_with_persons:
		across persons as p all persons_sorted_list.has (p.item) end
	persons_coincides_with_list:
		across persons_sorted_list as p all attached persons[p.item.get_id] and then persons[p.item.get_id] ~ p.item end
	married_to_coincides_with_persons:
		across married_to as m all persons.has_key (m.key) and persons.has (m.item) end
	marriage_table_duality:
		across married_to as l all l.key = married_to[married_to[l.key]] end
	dead_and_single_spouse_of_self:
		across persons as p all (p.item.get_status ~ "Single" or p.item.get_status ~ "Deceased") implies married_to[p.item.get_id] = p.item.get_id end

end




