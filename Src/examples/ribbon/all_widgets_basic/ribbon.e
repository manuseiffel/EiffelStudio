note
	description: "[
					Generated by EiffelRibbon tool
					Don't edit this file, since it will be replaced by EiffelRibbon tool
					generated files everytime
																							]"
	date: "$Date$"
	revision: "$Revision$"

class
	RIBBON

inherit
	EV_RIBBON
		redefine
			init_with_window
		end
		
create
	make

feature {NONE} -- Initialization

	make
			-- Creation method
		do
			create_interface_objects			
		end

	create_interface_objects
			-- Create objects
		do
			create tab_1.make_with_command_list (<<{COMMAND_NAME_CONSTANTS}.tab_1>>)

			create tabs.make (1)
			tabs.extend (tab_1)

		end

feature -- Command

	init_with_window (a_window: EV_WINDOW)
			-- <Precursor>
		do
			Precursor (a_window)
			-- You could call setModes here

		end
		
feature -- Query
	tab_1: TAB_1


end
