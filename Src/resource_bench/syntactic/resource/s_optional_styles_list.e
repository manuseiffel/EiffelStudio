indexing
	description: "xxx"
	product: "Resource Bench"
	date: "$Date$"
	revision: "$Revision$"

-- Optional_styles_list -> "," Styles_list Optional_extended_styles_list

class S_OPTIONAL_STYLES_LIST

inherit
	RB_AGGREGATE
		rename 
			make as old_make
		end

creation
	make

feature 

	make is
		do
			old_make
			set_optional
		end

	construct_name: STRING is
		once
			Result := "OPTIONAL_STYLES_LIST"
		end

	production: LINKED_LIST [CONSTRUCT] is
		local
			styles_list: STYLES_LIST
			optional_extended_styles_list: OPTIONAL_EXTENDED_STYLES_LIST
		once
			!! Result.make
			Result.forth

			keyword (",")
			commit

			!! styles_list.make
			put (styles_list)

			!! optional_extended_styles_list.make
			put (optional_extended_styles_list)
		end

end -- class S_OPTIONAL_STYLES_LIST

--|---------------------------------------------------------------
--|   Copyright (C) Interactive Software Engineering, Inc.      --
--|    270 Storke Road, Suite 7 Goleta, California 93117        --
--|                   (805) 685-1006                            --
--| All rights reserved. Duplication or distribution prohibited --
--|---------------------------------------------------------------
