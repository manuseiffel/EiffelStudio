indexing
	description: "Objects that represent a command for the deletion of a window object."
	date: "$Date$"
	revision: "$Revision$"

class
	GB_COMMAND_DELETE_WINDOW_OBJECT
	
inherit
	
	GB_SHARED_OBJECT_HANDLER
		export
			{NONE} all
		end
	
	GB_COMMAND
		export
			{NONE} all
		end
	
	GB_SHARED_HISTORY
		export
			{NONE} all
		end
	
	GB_SHARED_OBJECT_EDITORS
		export
			{NONE} all
		end
	
	GB_SHARED_COMMAND_HANDLER
		export
			{NONE} all
		end
	
	GB_WIDGET_UTILITIES
		export
			{NONE} all
		end
		
	GB_SHARED_TOOLS
		export
			{NONE} all
		end
		
	GB_FILE_UTILITIES
		export
			{NONE} all
		end
	
	INTERNAL
		export
			{NONE} all
		end
	
create	
	make
	
feature {NONE} -- Initialization

	make (window: GB_TITLED_WINDOW_OBJECT) is
			-- Create `Current' with `child' to be removed from `parent' at
			-- position `position'.
		require
			window_not_void: window /= Void
		local
			parent_item: EV_TREE_ITEM
		do
			History.cut_off_at_current_position
			parent_item ?= window.window_selector_item.parent
			if parent_item /= Void then
					-- If held in a directory, store the directory name.
				parent_directory := parent_item.text
			end
			original_id := window.id
		end

feature -- Basic Operation

	execute is
			-- Execute `Current'.
		local
			window_object: GB_TITLED_WINDOW_OBJECT
			file_name: FILE_NAME
			full_implementation_file_name, full_file_name: FILE_NAME
			file_location: FILE_NAME
		do
			window_object ?= Object_handler.deep_object_from_id (original_id)
			check
				object_was_window: window_object /= Void
			end
			object_handler.update_for_delete (original_id)
			object_handler.update_object_editors_for_delete (window_object, Void)
			window_object.layout_item.unparent
			window_object.window_selector_item.unparent
			object_handler.mark_as_deleted (window_object)
			
				-- Now actually destroy the physical files.
			create file_location.make_from_string (generated_path)
			if parent_directory /= Void then
				file_location.extend (parent_directory)
			end
				
				-- Store the _IMP file.
			create full_file_name.make_from_string (file_location.string)
			full_file_name.extend ((window_object.name + Class_implementation_extension).as_lower + ".e")
			store_file_contents (full_file_name)
			implementation_file_contents := last_stored_string
			
				-- Store the interface file.
			create full_file_name.make_from_string (file_location.string)
			full_file_name.extend (window_object.name + ".e")
			store_file_contents (full_file_name)
			file_contents := last_stored_string
			
				-- Remove the files from the disk.
			delete_file (create {DIRECTORY}.make (file_location), (window_object.name + Class_implementation_extension).as_lower + ".e")
			delete_file (create {DIRECTORY}.make (file_location), window_object.name + ".e")
			
				-- Record `Current' in the history list.
			if not history.command_list.has (Current) then
				history.add_command (Current)
			end
			command_handler.update
		end
		
	store_file_contents (file_name: FILE_NAME) is
			-- Store contents of file `file_name' as text in `last_stored_string'.
		require
			file_name_not_void: file_name /= Void
		local
			file: PLAIN_TEXT_FILE
		do
			create file.make (file_name)
			if file.exists then
				file.open_read_write
				file.read_stream (file.count)
				last_stored_string := file.laststring
				file.close
			end
		end
		
	last_stored_string: STRING
		-- Last string stored as  result of a call to `store_file_contents'.

	undo is
			-- Undo `Current'.
			-- Calling `execute' followed by `undo' must restore
			-- the system to its previous state.
		local
			window_object: GB_TITLED_WINDOW_OBJECT
			directory_item: GB_WINDOW_SELECTOR_DIRECTORY_ITEM
			file_name: FILE_NAME
		do
			window_object ?= Object_handler.deep_object_from_id (original_id)
			check
				object_was_window: window_object /= Void
			end
			object_handler.mark_existing (window_object)
			if parent_directory /= Void then
					-- Only try to retrieve the directory item if there was one.
				directory_item := window_selector.directory_object_from_name (parent_directory)
			end
			if directory_item = Void then
				-- Now simply add as root.
				Window_selector.extend (window_object.window_selector_item)
			else
				-- Restore window into original directory.
				directory_item.extend (window_object.window_selector_item)
			end
				-- Now actually restore the physical files.
			create file_name.make_from_string (generated_path)
			if parent_directory /= Void then
				file_name.extend (parent_directory)				
			end
				-- Restore the implementation file.
			if implementation_file_contents /= Void then
				restore_file (create {DIRECTORY}.make (file_name), (window_object.name + Class_implementation_extension).as_lower + ".e", implementation_file_contents)
			end
			
				-- Restore the interface file.
			if file_contents /= Void then
				restore_file (create {DIRECTORY}.make (file_name), window_object.name + ".e", file_contents)
			end
			command_handler.update
		end
		
	textual_representation: STRING is
			-- Text representation of command exectuted.
		local
			window_name: STRING
			window_object: GB_TITLED_WINDOW_OBJECT
		do
			window_object ?= Object_handler.deep_object_from_id (original_id)
			check
				object_was_window: window_object /= Void
			end
			if not window_object.name.is_empty then
				window_name := window_object.name
			else
				window_name := window_object.short_type
			end
			Result := window_name + " removed from the project"
		end
	
feature {NONE} -- Implementation

	parent_directory: STRING
		-- Orignal directory containing object referenced by `original_id' before deletion.

	original_id: INTEGER
		-- id of object that was deleted.
		
	file_contents: STRING
		-- Contents of file before deletion or Void if there was no file.
		
	implementation_file_contents: STRING
		-- Contents of IMP file after deletion
			
	generated_path: FILE_NAME is
			-- `Result' is generated directory for current project.
		do
			create Result.make_from_string (system_status.current_project_settings.project_location)
		ensure
			result_not_void: Result /= Void
		end

end -- class GB_COMMAND_DELETE_WINDOW_OBJECT
