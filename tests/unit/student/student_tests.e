note
	description: "Summary description for {STUDENT_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TESTS

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			add_boolean_case (agent t_create_citizen)
			add_boolean_case (agent t_create_alien)
			add_boolean_case (agent t_registry_valid_put)
			add_boolean_case (agent t_registry_valid_put_alien)
			add_boolean_case (agent t_registry_die_single)
			add_boolean_case (agent t_person_set_married_to)
			add_boolean_case (agent t_registry_marry)
			add_boolean_case (agent t_registry_die_married)
			add_boolean_case (agent t_registry_divorce)
			add_boolean_case (agent t_registry_is_valid_marriage)
			add_boolean_case (agent t_test_inv)
			add_boolean_case (agent t_test_inv2)
		end

feature -- test Citizen creation

	t_create_citizen: BOOLEAN
		local
			p: PERSON
			dob: DATE
		do
			comment("t_create_citizen: test citizen creation")
			create {DATE} dob.make (1990, 1, 1)
			create {CITIZEN} p.make (1, "Bob", dob)
			Result := p.get_id = 1 and p.get_name ~ "Bob" and p.get_dob ~ dob and p.get_citizenship ~ "Canada" and p.get_status ~ "Single"
		end

	t_create_alien: BOOLEAN
		local
			p: PERSON
			dob: DATE
		do
			comment("t_create_alien: test alien creation")
			create {DATE} dob.make (1990, 1, 1)
			create {ALIEN} p.make (1, "Bob", dob, "England")
			Result := p.get_id = 1 and p.get_name ~ "Bob" and p.get_dob ~ dob and p.get_citizenship ~ "England" and p.get_status ~ "Single"
		end

	t_registry_valid_put: BOOLEAN
		local
			r: REGISTRY_ACCESS
			dob: DATE
		do
			comment("t_registry_valid_put: test a valid put call")
			create dob.make (1990, 1, 1)
			r.m.put (1, "Bob", dob)
			Result := true
		end

	t_registry_valid_put_alien: BOOLEAN
		local
			r: REGISTRY_ACCESS
			dob: DATE
		do
			comment("t_registry_valid_put_alien: test a valid put_alien call")
			create dob.make (1992, 3, 22)
			r.m.put_alien (2, "Dan", dob, "France")
			Result := true
		end

	t_registry_die_single: BOOLEAN
		local
			r: REGISTRY_ACCESS
			dob: DATE
		do
			comment("t_registry_die_single: test die call on person who is single")
			create dob.make (1950, 6, 6)
			r.m.put_alien (3, "Fred", dob, "England")
			r.m.die (3)
			Result := true
		end

	t_person_set_married_to: BOOLEAN
		local
			p1: PERSON
			p2: PERSON
			dob1: DATE
			dob2: DATE
			date: DATE
		do
			comment("t_person_set_married_to: test setting marriage status")
			create {DATE} dob1.make (1990, 1, 1)
			create {CITIZEN} p1.make (1, "Bob", dob1)
			create {DATE} dob2.make (1991, 2, 3)
			create {CITIZEN} p2.make (2, "Jill", dob2)

			create {DATE} date.make (2020, 6, 10)
			p1.set_married_to (p2, date)
			p2.set_married_to (p1, date)
			Result := p2.get_status ~ "Spouse: Bob,1,[2020-06-10]" and p1.get_status ~ "Spouse: Jill,2,[2020-06-10]"
		end

	t_registry_marry: BOOLEAN
		local
			r: REGISTRY_ACCESS
			dob1: DATE
			dob2: DATE
			date: DATE
		do
			comment("t_registry_marry: test a valid marriage")
			create dob1.make (1955, 6, 6)
			r.m.put_alien (4, "David", dob1, "Ireland")
			create dob2.make (1955, 7, 7)
			r.m.put_alien (5, "Samantha", dob2, "Ireland")

			create date.make (1975, 6, 9)
			r.m.marry (4, 5, date)

			Result := true
		end

	--change once we have the marry command
	t_registry_die_married: BOOLEAN
		local
			r: REGISTRY_ACCESS
			dob1: DATE
			dob2: DATE
			date: DATE
		do
			comment("t_registry_die_married: test die call on persons that are married")
			create dob1.make (1950, 6, 6)
			r.m.put_alien (6, "Fred", dob1, "England")
			create dob2.make (1955, 7, 7)
			r.m.put_alien (7, "Jill", dob2, "England")

			create date.make (1975, 9, 9)
			r.m.marry (6, 7, date)

			Result := true
		end

	t_registry_divorce: BOOLEAN
		local
			r: REGISTRY_ACCESS
			dob1: DATE
			dob2: DATE
			date: DATE
		do
			comment("t_registry_divorce: test a valid divorce")
			create dob1.make (1965, 7, 8)
			r.m.put_alien (8, "George", dob1, "Denmark")
			create dob2.make (1965, 8, 9)
			r.m.put_alien (9, "Grace", dob2, "Denmark")

			create date.make (1985, 1, 9)
			r.m.marry (8, 9, date)

			r.m.divorce (8, 9)

			Result := true
		end

	t_registry_is_valid_marriage: BOOLEAN
		local
			r: REGISTRY_ACCESS
			dob1: DATE
			dob2: DATE
			m1: DATE
			m2: DATE
			m3: DATE
		do
			comment("t_registry_is_valid_marriage: test if is_valid_marriage query is working correctly")
			create dob1.make (1990, 1, 1)
			r.m.put (10, "Tom", dob1)
			create dob2.make (1995, 1, 1)
			r.m.put (11, "Sarah", dob2)

			create m1.make (2005, 1, 1)
			Result := r.m.valid_marriage (10, 11, m1) -- invalid m_date
			check not Result end

			create m2.make (2009, 1, 1)
			Result := r.m.valid_marriage (10, 11, m2) -- invalid m_date
			check not Result end

			create m3.make (2016, 2, 29) -- valid marriage and is leap year with date Feb 29
			Result := r.m.valid_marriage (10, 11, m3)

		end

	t_test_inv: BOOLEAN
		local
			r: REGISTRY_ACCESS
			s: STRING
			s2: STRING
		do
			comment("t_test_inv: test married_to is accurate_")
			create s.make_from_string (" ")
			create s2.make_from_string (" ")
			across
			r.m.married_to as l
			loop
				if (attached r.m.persons[l.key] as p1 and attached r.m.persons[r.m.married_to[l.key]] as p2) then
					s.append (p1.get_id.out + ", " + p1.get_name + " -> " + p2.get_id.out + ", " + p2.get_name + "%N")
				end
				s2.append (l.key.out + " -> " + r.m.married_to[l.key].out + "%N")
			end
			sub_comment(s + "<br /><br />")
			sub_comment(s2)
			Result := across r.m.married_to as l all l.key = r.m.married_to[r.m.married_to[l.key]] end
		end

	t_test_inv2: BOOLEAN
		local
			r: REGISTRY_ACCESS
			dob1: DATE
			dob2: DATE
			dob3: DATE
			dob4: DATE
			m_date1: DATE
			m_date2: DATE
			s: STRING
		do
			comment("t_test_inv2: test married_to duality issue")
			r.m.reset
			create dob1.make (1995, 2, 17)
			r.m.put_alien (3, "Bob", dob1, "England")
			create dob2.make (1990, 2, 15)
			r.m.put (1, "Joe", dob2)
			create dob3.make (1991, 3, 31)
			r.m.put_alien (4, "Kim", dob3, "France")
			create dob4.make (1991, 3, 31)
			r.m.put (2, "Pam", dob4)

			r.m.die (1)
			r.m.die (4)

			--till correct state

			create m_date1.make (2014, 6, 25)
			r.m.marry (3, 2, m_date1)

			create s.make_from_string (" " + "<br />")
			across
			r.m.married_to as l
			loop
				s.append (l.key.out + " -> " + r.m.married_to[l.key].out + "<br />")
			end

			sub_comment(s)

			Result := across r.m.married_to as l all l.key = r.m.married_to[r.m.married_to[l.key]] end
		end

end
