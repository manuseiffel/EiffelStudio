indexing
	description: "Command to update the Eiffel project."
	date: "$Date$"
	revision: "$Revision$"

class
	EB_MELT_PROJECT_CMD

inherit
	SHARED_APPLICATION_EXECUTION

	SHARED_EIFFEL_PROJECT

	SHARED_BENCH_LICENSES

	PROJECT_CONTEXT

	EB_TOOL_COMMAND
		redefine
			tool
		end

	SHARED_RESCUE_STATUS

	EB_SHARED_FORMAT_TABLES

--	WARNER_CALLBACKS
--		rename
--			execute_warner_help as choose_template,
--			execute_warner_ok as warner_ok
--		end

	SHARED_CONFIGURE_RESOURCES

	EB_SHARED_INTERFACE_TOOLS

	EB_PROJECT_TOOL_DATA

--	CREATE_ACE_CALLER

creation

	make

feature -- Callbacks

	choose_template is
		do
			load_default_ace
		end

--	warner_ok (argument: ANY) is
--		local
--			chooser: NAME_CHOOSER_W
--		do
--			chooser := name_chooser (popup_parent)
--			chooser.set_open_file
--			chooser.call (Current)
--		end

feature -- Properties

	is_precompiling: BOOLEAN is
			-- Is this compilation a precompilation?
		do
			-- False for a standard compilation
		end

--	symbol: EV_PIXMAP is
--			-- Pixmap for the button.
--		do
--			if is_quick_melt then
--				Result := Pixmaps.bm_Quick_update
--			else
--				Result := Pixmaps.bm_Update
--			end
--		end

	tool: EB_PROJECT_TOOL
			-- Project tool

	generate_code_only: EV_ARGUMENT1 [ANY] is
		once
			create Result.make (Void)
		end

feature -- Status Setting

	set_run_after_melt (b: BOOLEAN) is
			-- Request for the system to be executed after a
			-- successful melt compilation or not.
			-- Assign `b' to `run_after_melt'.
		do
			run_after_melt2 := b
		end

feature {NONE} -- Implementation

	reset_debugger is
			-- Kill the application, if it is running.
		do
			if Application.is_running then
				Application.kill
			end
		end

	compile (argument: ANY) is
			-- Compile, in the one way or the other.
		local
			rescued: BOOLEAN
			st: STRUCTURED_TEXT
			title: STRING
--			mp: MOUSE_PTR
			wd: EV_WARNING_DIALOG
		do
			if not rescued then
				if not Eiffel_project.is_compiling then
					reset_debugger
--					error_window.clear_window
--					!! mp.set_watch_cursor
					tool.update_compile_access (is_precompiling or Compilation_modes.is_precompiling)
					perform_compilation

					if Eiffel_project.successful then
							-- If a freezing already occured (due to a new external
							-- or new derivation of SPECIAL), no need to freeze again.
						title := clone (Interface_names.t_Project)
						title.append (" : ")
						title.append (Project_directory_name)
						tool.set_title (title)
						if Eiffel_project.save_error then
							!! st.make
							st.add_string ("Could not write to ")
							st.add_string (Project_directory_name)
							st.add_new_line
							st.add_string ("Please check permissions and disk space")
							st.add_new_line
							st.add_string ("Then press ")
							st.add_string (name)
							st.add_string (" again")
							st.add_new_line
							error_window.process_text (st)
						else
							if not finalization_error then
								launch_c_compilation (argument)
							end
						end
					end

--					mp.restore
--					error_window.display
--					tool_resynchronization (argument)
					Degree_output.finish_degree_output
				end
			else
					-- The project may be corrupted => the project
					-- becomes read-only.
				create wd.make_default (tool.parent, Interface_names.t_Warning, Warning_messages.w_Project_may_be_corrupted)

--				error_window.display
--				tool_resynchronization (argument)
				Degree_output.finish_degree_output
			end

		rescue
			if not fail_on_rescue then
				if original_exception = Io_exception then
						-- We probably don't have the write permissions
						-- on the server files.
					rescued := true
					retry
				end
			end
		end

	tool_resynchronization (argument: ANY) is
			-- Resynchronize class, feature and system tools.
			-- Clear the format_context buffers.
		local
			saved_msg, messages: STRING
			er_w: EB_FORMATTED_TEXT
		do
				-- `image' is a once function which will be overwritten
				-- during the resynchronization of the class and feature
				-- tools. We need a copy of it to keep track of various
				-- error messages generated by the compilation.
			er_w ?= error_window
			messages := er_w.text
			create saved_msg.make (messages.count)
			saved_msg.append (messages)
			if tool_supervisor.has_active_editor_tools then
--				Degree_output.put_string (Interface_names.d_Resynchronizing_tools)
				tool_supervisor.class_tool_mgr.synchronize_to_default
				tool_supervisor.feature_tool_mgr.synchronize_to_default
			end
			debug_tool.synchronize_routine_tool_to_default
			if
				system_tool_is_valid and then
				system_tool.shown
			then
				system_tool.set_default_format
				system_tool.synchronize
			end

--			if
--				is_dynamic_lib_tool_created and then
--				dynamic_lib_tool.realized and then
--				dynamic_lib_tool.shown
--			then
--				dynamic_lib_tool.set_default_format
--				dynamic_lib_tool.synchronize
--			end

			messages.wipe_out
			messages.append (saved_msg)

				-- Clear the format_context buffers.
			clear_format_tables
		end

	launch_c_compilation (argument: ANY) is
			-- Launch the C compilation.
		local
			window: EB_CLICKABLE_RICH_TEXT
		do
			window ?= Error_window
			if window /= Void then
				window.set_changed (True)
			end

			Error_window.put_string ("System recompiled%N")
	
			if start_c_compilation then
				if Eiffel_project.freezing_occurred then
					error_window.put_string	("System had to be frozen to include new externals.%N%
									%Background C compilation launched.%N")
					Eiffel_project.call_finish_freezing (True)
				end
			end

			if window /= Void then
				window.set_changed (False)
			end
		end

	confirm_and_compile (argument: ANY) is
			-- Ask for a confirmation, and thereafter compile.
		do
			if
				not Application.is_running
-- or else
--				(argument /= Void and
--				argument = last_confirmer and end_run_confirmed)
			then
				compile (argument)
				if 
					run_after_melt and then
					Eiffel_ace.file_name /= Void and then
					Eiffel_project.successful and 
					not Eiffel_project.freezing_occurred
				then
						-- The system has been successfully melted.
						-- The system can be executed as required.
--					tool.debug_run_cmd_holder.associated_command.execute (text_window)
				end
			else
				end_run_confirmed := true
--				confirmer (popup_parent).call (Current,
--						"Recompiling project will end current run.%N%
--						%Start compilation anyway?", "Compile")
			end
		end

	perform_compilation is
			-- The real compilation. (This is melting.)
		do
			license_display
			Eiffel_project.melt
		end

	load_default_ace is
			-- Load the default ace file.
		require
			tool.initialized
		local
--			wizard: WIZARD
		do
--			!! wizard.make (Project_tool, wiz_dlg, ace_b)
--			wizard.execute_action
		end

	perform_post_creation is
		local
--			file_name: STRING
		do
--			!! file_name.make (0)
--			file_name.append ("Ace.ace")
--			Eiffel_ace.set_file_name (file_name)
--			wiz_dlg.popdown
--			confirm_and_compile (Void)
		end

feature {NONE} -- Attributes

--	wiz_dlg: WIZARD_DIALOG is
--			-- Dialog used to display the wizard.
--		once
--			!! Result.make (Interface_names.t_Ace_builder, Project_tool)
--		end

	not_saved: BOOLEAN is
			-- Has the text of some tool been edited and not saved?
		do
--			Result := tool_supervisor.class_tool_mgr.changed or else
--						(is_system_tool_created and then system_tool.changed)
		end

	finalization_error: BOOLEAN is
			-- Has a validity error been detected during the
			-- finalization? This happens with DLE dealing
			-- with statically bound feature calls
		do
		end

	end_run_confirmed: BOOLEAN
			-- Was the last confirmer popped up to confirm the end of run?

	start_c_compilation: BOOLEAN
			-- Do we have to start the C compilation after C Code generation?

	run_after_melt: BOOLEAN
			-- Should we execute the system after sucessful melt?

	run_after_melt2: BOOLEAN
			-- Should we execute the system after sucessful melt?
			-- This boolean value is only reliable at the beginning
			-- of the execution of this command. After a warning or
			-- confirmation panel has been popped up, this value
			-- can be cleared by the caller. To prevent that, we
			-- keep track of that value in `run_after_melt' at the 
			-- beginning of the execution, so that we can still 
			-- rely on it after a confirmation when we resume 
			-- (i.e. re-execute) the command

	retried: BOOLEAN
			-- Is this already tried?

	c_code_directory: STRING is
			-- Directory where the C code is stored.
		do
			Result := Workbench_generation_path
		end

	name: STRING is
			-- Name of the command.
		do
			Result := Interface_names.f_Update
		end

--	menu_name: STRING is
--			-- Name used in menu entry
--		do
--			if is_quick_melt then
--				Result := Interface_names.m_Quick_update
--			else
--				Result := Interface_names.m_Update
--			end
--		end

--	accelerator: STRING is
--			-- Accelerator action for menu entry
--		do
--			if is_quick_melt then
--				Result := Interface_names.a_Quick_Update
--			else
--				Result := Interface_names.a_Update
--			end
--		end

--	ace_b: ACE_BUILDER is
--			-- Wizard action to generate ace file (the only one)
--			-- At the moment there is only one step
--		once
--			!! Result.make (Current)
--		end

feature {NONE} -- Implementation Execution

	execute (argument: EV_ARGUMENT1 [ANY]; data: EV_EVENT_DATA) is
			-- Recompile the project.
		local
			fn: STRING
			f: PLAIN_TEXT_FILE
			temp: STRING
			arg: ANY
		do
			if argument /= Void then
				if argument.first = generate_code_only then
					arg := tool
					start_c_compilation := False
					run_after_melt := false
				else
					if argument.first = tool then
						start_c_compilation := True
							-- Should we execute the system after sucessful melt?
							-- (See header comment of `run_after_melt2'.)
						run_after_melt := run_after_melt2
					end
					arg := argument.first
				end
			end
			if Eiffel_project.is_read_only then
--				warner (popup_parent).gotcha_call (Warning_messages.w_Cannot_compile)
			elseif tool.initialized then
				if not_saved and arg = tool then
					end_run_confirmed := false
--					confirmer (popup_parent).call (Current, "Some files have not been saved.%NStart compilation anyway?", "Compile")
				else
					if Eiffel_ace.file_name /= Void then
						confirm_and_compile (arg)
						if Project_resources.raise_on_error.actual_value then
							tool.raise
						end
					elseif arg = Void then
						choose_template
--					elseif arg = last_warner then
--						warner_ok (arg)
--					elseif arg = last_name_chooser then
--						fn := clone (last_name_chooser.selected_file)
--						if not fn.empty then
--							!! f.make (fn)
--							if
--								f.exists and then 
--								f.is_readable and then 
--								f.is_plain
--							then
--								Eiffel_ace.set_file_name (fn)
--								work (Current)
--							elseif f.exists and then not f.is_plain then
--								warner (popup_parent).custom_call (Current,
--								Warning_messages.w_Not_a_file_retry (fn), Interface_names.b_Ok, Void, Interface_names.b_Cancel)
--							else
--								warner (popup_parent).custom_call
--									(Current, Warning_messages.w_Cannot_read_file_retry (fn),
--									Interface_names.b_Ok, Void, Interface_names.b_Cancel)
--							end
--						else
--							warner (popup_parent).custom_call (Current,
--								Warning_messages.w_Not_a_file_retry (fn), Interface_names.b_Ok, Void, Interface_names.b_Cancel)
--						end
					else
--						warner (popup_parent).custom_call (Current,
--							Warning_messages.w_specify_ace, Interface_names.b_Browse, Interface_names.b_Build, Interface_names.b_Cancel)
					end
				end
			end
		end

	license_display is
			-- Display the license reminder.
		do
--			if license.demo_mode then
--				number_of_compilations := number_of_compilations + 1
--				if number_of_compilations \\ license_frequency = 0 then
--					license.get_license
--				end
--			end
		end

feature {NONE} -- Implementation

	license_frequency: INTEGER is
			-- Frequency of license appearance in demo mode.
		once
			Result := 5
		end

	number_of_compilations: INTEGER
			-- Number of compilations done in a certain mode so far.

end -- class EB_MELT_PROJECT_CMD
