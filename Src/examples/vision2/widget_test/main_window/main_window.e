indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAIN_WINDOW

inherit
	MAIN_WINDOW_IMP
	
	WIDGET_TEST_SHARED
		undefine
			copy, default_create, is_equal
		end
		
	SHARED_TEST_CONTROLLER
		undefine
			copy, default_create, is_equal
		end
		
	GENERATION_CONSTANTS
		undefine
			copy, default_create, is_equal
		end

feature {NONE} -- Initialization

	user_initialization is
			-- called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		local
			type_selector: GB_TYPE_SELECTOR
			editor: GB_OBJECT_EDITOR
			event_selector: EVENT_SELECTOR
			documentation_display: DOCUMENTATION_DISPLAY
		do
				-- The first type change agent that we register locks the update, so
				-- that the user does not see the changes taking place.
			register_type_change_agent (agent lock_current)
			
				-- Create the editor and parent.
			create editor
			object_editor.extend (editor)

				-- Create the type selector and parent.
			create type_selector
			widget_selector_parent.extend (type_selector)
			
				-- Create the test controller.
			test_controller.set_class_output (test_class_display)
			controller_parent.extend (test_controller)
			
				-- Create the documentation display
			create documentation_display.make_with_text (flat_short_display)
			register_type_change_agent (agent documentation_display.update_for_type_change)

			
			create event_selector.make_with_list_and_handler (event_selector_list, event_handler)
			register_type_change_agent (agent event_selector.rebuild)
			
				-- Register a change agent which parents the new test widget.
			register_type_change_agent (agent parent_test_widget)
			
				-- Register a change agent which removes the start up screen.
			register_type_change_agent (agent remove_first_screen)
			
				-- The last type change agent we register unlocks the current
				-- window, so that we can see any changes to the interface.
			register_type_change_agent (agent unlock_current)
			
				-- Ensure that the three tool bar buttons behave as radio buttons.
			properties_button.select_actions.extend (agent update_tool_bar_radio_buttons (properties_button))			
			tests_button.select_actions.extend (agent update_tool_bar_radio_buttons (tests_button))			
			documentation_button.select_actions.extend (agent update_tool_bar_radio_buttons (documentation_button))
			main_notebook.selection_actions.extend (agent update_buttons)
			
				-- Initialize button pixmaps.
			initialize_pixmaps
			
				-- Set up search tool
			search_tool.associate_text_entry (search_field)
			
				-- Connect events to `generation_button'
			generate_button.select_actions.extend (agent perform_generation)
			
			setup_initial_screen
		end

feature {NONE} -- Implementation

	display_about_dialog is
			-- Display an instace of ABOUT_DIALOG
			-- modally to `Current'.
		local
			about_dialog: ABOUT_DIALOG
		do
			create about_dialog.make
			about_dialog.show_modal_to_window (Current)
		end
		

	set_window_title (a_widget: EV_WIDGET) is
			-- Assign a title to `Current', reflecting type
			-- of widget that is currently being tested.
		do
			set_title ("Testing - " + test_widget_type + ".")
		end
		

	parent_test_widget (a_widget: EV_WIDGET) is
			-- Ensure `a_widget' is parented in
			-- `widget_holder'.
		do
			widget_holder.wipe_out
			
				-- We must now rebuild `widget_holder' to ensure
				-- that no minimum size settings still apply. This
				-- will ensure that each test will be at the default size,
				-- even if the last was large.
			vertical_spacing_box.prune (widget_holder)
			create widget_holder
			vertical_spacing_box.go_i_th (2)
			vertical_spacing_box.put_left (widget_holder)
			scrollable_widget_area.set_item_height (310)
			scrollable_widget_area.set_item_width (310)
			
			widget_holder.extend (a_widget)
				-- Now clear recorded events, as a widget has changed.
			clear_events
		end
		
	select_all_events is
			-- Select all events in `event_selector_list'.
		do
			from
				event_selector_list.start
			until
				event_selector_list.off
			loop
				event_selector_list.check_item (event_selector_list.item)
				event_selector_list.forth
			end
		end
		
	clear_all_events is
			-- Clear all events in `event_selector_list'.
		do
			from
				event_selector_list.start
			until
				event_selector_list.off
			loop
				event_selector_list.uncheck_item (event_selector_list.item)
				event_selector_list.forth
			end
		end
		
	clear_events is
			-- Reset `event_selector_list'.
		do
			event_handler.reset	
		end
		
	event_handler: ORDERED_STRING_HANDLER is
			-- Once access to an ORDERED_STRING_HANDLER.
		once
			create Result.make_with_textable (event_output)
		end
		
	setup_initial_screen is
			-- Display initial start up scren which will be displayed until a
			-- widget type is selected.
		local
			label: EV_LABEL
		do
			test_class_display.set_background_color ((create {EV_STOCK_COLORS}).white)
			flat_short_display.set_background_color ((create {EV_STOCK_COLORS}).white)
			main_split_area.prune (main_box)
			create label.make_with_text ("Please select a widget to begin exploration")
			main_split_area.extend (label)
			label.set_background_color ((create {EV_STOCK_COLORS}).white)
		end
		
	remove_first_screen (v: EV_WIDGET) is
			-- Remove initial start up screen.
			-- Note that this is called every time the widget type
			-- changes, but will do nothing after the first time.
		do
			if not main_split_area.has (main_box) then
				main_split_area.go_to_second
				main_split_area.replace (main_box)
			end
			
				-- Now enable the tool bar buttons.
			properties_button.enable_sensitive
			properties_button.enable_select
			tests_button.enable_sensitive
			documentation_button.enable_sensitive
				
		ensure
			main_split_area.has (main_box)
		end
		
	lock_current (v: EV_WIDGET) is
			-- Calls `lock_update' but with a signature that allows
			-- it to be registered as a type change agent.
		do
			lock_update
		end
		
	unlock_current (v: EV_WIDGET) is
			-- Calls `unlock_update' but with a signature that allows
			-- it to be registered as a type change agent.
		do
			unlock_update
		end
		
	update_tool_bar_radio_buttons (selected_button: EV_TOOL_BAR_TOGGLE_BUTTON) is
			-- Simulate radio button behaviour on the three buttons in
			-- the seperate tool bars.
		do
			if selected_button /= properties_button then
				properties_button.select_actions.block
				properties_button.disable_select
				properties_button.select_actions.resume
			else
				main_notebook.select_item (main_notebook_properties_item)
				generate_button.disable_sensitive
				file_generate.disable_sensitive
			end
			if selected_button /= tests_button then
				tests_button.select_actions.block
				tests_button.disable_select
				tests_button.select_actions.resume
			else
				main_notebook.select_item (main_notebook_tests)
				generate_button.enable_sensitive
				file_generate.enable_sensitive
			end
			if selected_button /= documentation_button then
				documentation_button.select_actions.block
				documentation_button.disable_select
				documentation_button.select_actions.resume
			else
				main_notebook.select_item (flat_short_display_parent)
				generate_button.disable_sensitive
				file_generate.disable_sensitive
			end
		end
		
	update_buttons is
			-- Update tool bar buttons to track notebook selections.
		do
			if main_notebook.selected_item = main_notebook_properties_item then
				properties_button.enable_select
			end
			if main_notebook.selected_item = main_notebook_tests then
				tests_button.enable_select
			end
			if main_notebook.selected_item = flat_short_display then
				documentation_button.enable_select
			end
		end

	initialize_pixmaps is
			-- Assign pixmaps to buttons as necessary.
		local
			pixmap: EV_PIXMAP
		do
			create pixmap
			pixmap.set_with_named_file ("D:\work\widget_test\bitmaps\ico\properties.ico")
			properties_button.set_pixmap (pixmap)
			
			create pixmap
			pixmap.set_with_named_file ("D:\work\widget_test\bitmaps\ico\testing.ico")
			tests_button.set_pixmap (pixmap)

			create pixmap
			pixmap.set_with_named_file ("D:\work\widget_test\bitmaps\ico\documentation.ico")
			documentation_button.set_pixmap (pixmap)
			
			create pixmap
			pixmap.set_with_named_file ("D:\work\widget_test\bitmaps\ico\icon_code_generation_color.ico")
			generate_button.set_pixmap (pixmap)
		end
		
	perform_generation is
			-- User has requested to generate a test, so
			-- display a GENERATION_DIALOG.
		local
			generation_dialog: GENERATION_DIALOG
		do
			create generation_dialog
			generation_dialog.set_message ("You have selected to generate the " + Test_controller.selected_test_name +
			"%N%NThe following files will be generated:%N" + application_file_name + "%N" + ace_file_name + "%N" + Common_test_file_name + "%N" +
			Test_controller.selected_test_name + ".e%N%NPlease specify a directory and then click %"Ok%" to generate the project:")	
			generation_dialog.show_modal_to_window (Current)
		end
		
	close_test is
			-- Close `Current' and destroy application.
		do
			(create {EV_ENVIRONMENT}).application.destroy
		end

	update_case_matching is
			-- User has selected `match_case_button' so update
			-- search tool.
		do
			if match_case_button.is_selected then
				search_tool.enable_case_matching
			else
				search_tool.disable_case_matching
			end
		end
		
	start_search is
			-- User has selected `search_button' so start
			-- a search
		do
			search_tool.search (search_field.text)
		end
		
	search_tool: SEARCH_TOOL is
			-- Once access to a SEARCH_TOOL which allows
			-- an EV_TEXT to be searched.
		once
			Create Result.make_with_ev_text (flat_short_display)
		end
		
		
	
end -- class MAIN_WINDOW

