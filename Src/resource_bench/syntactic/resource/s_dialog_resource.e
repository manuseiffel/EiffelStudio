indexing
	description: "xxx"
	product: "Resource Bench"
	date: "$Date$"
	revision: "$Revision$"

-- Dialog_resource -> "DIALOG" Dialog_options "BEGIN" Control_statement_list "END"

class S_DIALOG_RESOURCE

inherit
	RB_AGGREGATE

feature 

	construct_name: STRING is
		once
			Result := "DIALOG_RESOURCE"
		end

	production: LINKED_LIST [CONSTRUCT] is
		local
			options: DIALOG_OPTIONS
			begin1: BEGIN_BLOCK
			control_list: CONTROL_STATEMENT_LIST
			end1: END_BLOCK
		once
			!! Result.make
			Result.forth

			keyword ("DIALOG")
			commit

			!! options.make
			put (options)

			!! begin1.make
			put (begin1)

			!! control_list.make
			put (control_list)
			
			!! end1.make
			put (end1)
		end

end -- class S_DIALOG_RESOURCE

--|---------------------------------------------------------------
--|   Copyright (C) Interactive Software Engineering, Inc.      --
--|    270 Storke Road, Suite 7 Goleta, California 93117        --
--|                   (805) 685-1006                            --
--| All rights reserved. Duplication or distribution prohibited --
--|---------------------------------------------------------------
