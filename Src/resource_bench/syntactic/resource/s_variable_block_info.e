indexing
	description: "xxx"
	product: "Resource Bench"
	date: "$Date$"
	revision: "$Revision$"

-- Variable_block_info -> "BLOCK" "%"VarFileInfo%"" "BEGIN" Variable_value_list "END"

class S_VARIABLE_BLOCK_INFO

inherit
	RB_AGGREGATE

feature 

	construct_name: STRING is
		once
			Result := "VARIABLE_BLOCK_INFO"
		end

	production: LINKED_LIST [CONSTRUCT] is
		local
			begin1: BEGIN_BLOCK
			list: VARIABLE_VALUE_LIST
			end1: END_BLOCK
		once
			!! Result.make
			Result.forth
			
			keyword ("BLOCK")
			commit

			keyword ("%"VarFileInfo%"")

			!! begin1.make
			put (begin1)
			
			!! list.make
			put (list)

			!! end1.make
			put (end1)
		end

end -- class S_VARIABLE_BLOCK_INFO

--|---------------------------------------------------------------
--|   Copyright (C) Interactive Software Engineering, Inc.      --
--|    270 Storke Road, Suite 7 Goleta, California 93117        --
--|                   (805) 685-1006                            --
--| All rights reserved. Duplication or distribution prohibited --
--|---------------------------------------------------------------
