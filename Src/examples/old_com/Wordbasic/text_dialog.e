indexing 
	description: "ENTER_TEXT_DIALOG class created by Resource Bench."

class 
	TEXT_DIALOG

inherit
	WEL_MODAL_DIALOG
		redefine
			on_ok
		end

	APPLICATION_IDS
		export
			{NONE} all
		end
		
create
	make

feature {NONE} -- Initialization

	make (a_parent: WEL_COMPOSITE_WINDOW) is
			-- Create the dialog.
		require
			a_parent_not_void: a_parent /= Void
			a_parent_exists: a_parent.exists
		do
			make_by_id (a_parent, Text_dialog_constant)
			create id_ok.make_by_id (Current, Idok)
			create text_edit.make_by_id (Current, Text_edit_constant)
		end

feature -- Behavior

	on_ok is
			-- Action to be executed when user clicks OK:
			-- store text entry into `user_text'.
		do
			user_text := text_edit.text
			terminate (Idok)
		end

feature -- Access

	id_ok: WEL_PUSH_BUTTON
			-- OK button
			
	text_edit: WEL_SINGLE_LINE_EDIT
			-- Field for entering text
			
	user_text: STRING
			-- Text entered by user

end -- class ENTER_TEXT_DIALOG

--|-------------------------------------------------------------------
--| This class was automatically generated by Resource Bench
--| Copyright (C) 1996-1997, Interactive Software Engineering, Inc.
--|
--| 270 Storke Road, ISE building, second floor, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Information e-mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|-------------------------------------------------------------------------