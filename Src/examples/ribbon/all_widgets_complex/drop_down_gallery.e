﻿note
	description: "[
					Generated by EiffelRibbon tool
																							]"
	date: "$Date$"
	revision: "$Revision$"

class
	DROP_DOWN_GALLERY

inherit
	DROP_DOWN_GALLERY_IMP
		redefine
			create_interface_objects
		end

create
	{EV_RIBBON_GROUP} make_with_command_list

feature -- Query

	text: STRING_32 = "Ribbon drop down gallery"
			-- This is generated by EiffelRibbon tool

feature {NONE} -- initialization

	create_interface_objects
			-- <Precursor>
		do
			Precursor
			add_items_to_drop_down_gallery
		end

	add_items_to_drop_down_gallery
			-- Add items to dropdown gallery
		local
			l_list: ARRAYED_LIST [EV_RIBBON_DROP_DOWN_GALLERY_ITEM]
			l_item: EV_RIBBON_DROP_DOWN_GALLERY_ITEM
			l_pixel_buffer: EV_PIXEL_BUFFER
		do
			create l_list.make (2)
			create l_item
			create l_pixel_buffer
			l_pixel_buffer.set_with_named_file ("./res/5.bmp")
			l_item.set_image (l_pixel_buffer)
			l_item.set_label ("first item")
			l_item.select_actions.extend (agent do
													print ("%NDropdown gallery item 1 selected")
												end)
			l_list.extend (l_item)

			create l_item
			create l_pixel_buffer
			l_pixel_buffer.set_with_named_file ("./res/6.bmp")
			l_item.set_image (l_pixel_buffer)
			l_item.set_label ("second item")
			l_item.select_actions.extend (agent do
													print ("%NDropdown gallery item 2 selected")
												end)
			l_list.extend (l_item)

			set_item_source (l_list)
		end

end
