note
	description: "EiffelVision Widget ER_DROP_DOWN_GALLERY_NODE_WIDGET.%
		%The original version of this class was generated by EiffelBuild."
	generator: "EiffelBuild"
	date: "$Date$"
	revision: "$Revision$"

class
	ER_DROP_DOWN_GALLERY_NODE_WIDGET

inherit
	ER_DROP_DOWN_GALLERY_NODE_WIDGET_IMP


feature {NONE} -- Initialization

	user_create_interface_objects
			-- Create any auxilliary objects needed for ER_DROP_DOWN_GALLERY_NODE_WIDGET.
			-- Initialization for these objects must be performed in `user_initialization'.
		do
				-- Create attached types defined in class here, initialize them in `user_initialization'.
			create checker
			create large_image.make
		end

	user_initialization
			-- Perform any initialization on objects created by `user_create_interface_objects'
			-- and from within current class itself.
		do
				-- Initialize types defined in current class
			large_image.set_browse_for_open_file ("")
			extend (large_image)
			disable_item_expand (large_image)
			if attached large_image.field as l_field then
				l_field.change_actions.extend (agent on_large_image_change)
			end
		end

feature -- Command

	set_tree_node_data (a_data: detachable ER_TREE_NODE_DROP_DOWN_GALLERY_DATA)
			--
		do
			tree_node_data := a_data
			if attached a_data as l_data then
				if attached a_data.command_name as l_command_name then
					command_name.set_text (l_command_name)
				else
					command_name.remove_text
				end

				if attached a_data.label_title as l_label_title then
					label.set_text (l_label_title)
				else
					label.remove_text
				end

--				if attached a_data.small_image as l_small_image then
--					small_image.set_text (l_small_image)
--				else
--					small_image.remove_text
--				end

				if attached a_data.large_image as l_large_image then
					large_image.set_text (l_large_image)
				else
					large_image.remove_text
				end

				rows.set_text (l_data.rows.out)
				columns.set_text (l_data.columns.out)
			end
		end

feature {NONE} -- Implementation

	large_image: EV_PATH_FIELD
			--

	checker: ER_IDENTIFIER_UNIQUENESS_CHECKER
			--

	tree_node_data: detachable ER_TREE_NODE_DROP_DOWN_GALLERY_DATA
			--

	on_command_name_focus_out
			-- <Precursor>
		do
			checker.on_focus_out (command_name, tree_node_data)
		end

	on_command_name_text_change
			-- <Precursor>
		do
			checker.on_identifier_name_change (command_name, tree_node_data)
		end

	on_label_text_change
			-- Called by `change_actions' of `label'.
		do
			if attached tree_node_data as l_data then
				l_data.set_label_title (label.text)
			end
		end

	on_large_image_change
			-- Called by `change_actions' of `large_image'.
		do
			if attached tree_node_data as l_data then
				l_data.set_large_image (large_image.text)
			end
		end

	on_rows_change
			-- Called by `change_actions' of `rows'.
		do
			if attached tree_node_data as l_data then
				if rows.text.is_integer then
					l_data.set_rows (rows.text.to_integer)
				end
			end
		end

	on_columns_change
			-- Called by `change_actions' of `columns'.
		do
			if attached tree_node_data as l_data then
				if columns.text.is_integer then
					l_data.set_columns (columns.text.to_integer)
				end
			end
		end

	on_gripper_select
			-- Called by `select_actions' of `gripper'.
		do
			if attached tree_node_data as l_data then
				l_data.set_gripper (gripper.is_selected)
			end
		end

end