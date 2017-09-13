note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	REGISTRY_ACCESS

feature
	m: REGISTRY
		once
			create Result.make
		end

invariant
	m = m
end




