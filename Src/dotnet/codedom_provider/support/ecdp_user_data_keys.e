indexing
	description	: "Keys used in user_data tables of codeDom objects."

class
	ECDP_USER_DATA_KEYS

feature -- Implementation

	From_eiffel_code_key: INTEGER is unique
			-- Specify that DOM has been generated by eiffel parser.

	Other_names: INTEGER is unique
			-- key to retrieve all names when a declaration contains multiple names.

	Feature_clients_key: INTEGER is unique
			-- key to retrieve clients associated to feature.

	Class_construtors: INTEGER is unique
			-- Key to retrieve list of creators of a class.

	Preconditions_key: INTEGER is unique
			-- key to retrieve preconditions.

	Postconditions_key: INTEGER is unique
			-- key to retrieve postconditions.

	Retry_feature: INTEGER is unique
			-- key to retrieve retry statements.

	Require_keyword: INTEGER is unique
			-- Require keyword for pre condition.

	Require_else_keyword: INTEGER is unique
			-- Require else keyword for pre condition.

	Ensure_keyword: INTEGER is unique
			-- Ensure keyword for post condition.

	Ensure_then_keyword: INTEGER is unique
			-- Ensure then keyword for post condition.

	Assertion_tag: INTEGER is unique
			-- Key to access tag associated to an assertion.

	Elseif_statement: INTEGER is unique
			-- Boolean key to declare if a condition_statement is an elseif or a if statement.

	Constructor_name_key: INTEGER is unique
			-- key to retrieve constructor name of a creation expression.

	Start_position: INTEGER is unique
			-- Key to access the start position of current element.

	End_position: INTEGER is unique
			-- Key to access the end position of current element.

	Line_start_position: INTEGER is unique
			-- Key to access the line start position of current element.

	Line_end_position: INTEGER is unique
			-- Key to access the line end position of current element.

	Column_start_position: INTEGER is unique
			-- Key to access the column start position of current element.

	Column_end_position: INTEGER is unique
			-- Key to access the column end position of current element.

end -- ECDP_USER_DATA_KEYS

--+--------------------------------------------------------------------
--| Eiffel CodeDOM Provider
--| Copyright (C) 2001-2004 Eiffel Software
--| Eiffel Software Confidential
--| All rights reserved. Duplication and distribution prohibited.
--|
--| Eiffel Software
--| 356 Storke Road, Goleta, CA 93117 USA
--| http://www.eiffel.com
--+--------------------------------------------------------------------
