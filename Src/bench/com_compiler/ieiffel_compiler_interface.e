indexing
	description: "Eiffel Compiler.  Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

deferred class
	IEIFFEL_COMPILER_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Status Report

	compile_user_precondition: BOOLEAN is
			-- User-defined preconditions for `compile'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	finalize_user_precondition: BOOLEAN is
			-- User-defined preconditions for `finalize'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	precompile_user_precondition: BOOLEAN is
			-- User-defined preconditions for `precompile'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	compile_to_pipe_user_precondition: BOOLEAN is
			-- User-defined preconditions for `compile_to_pipe'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	finalize_to_pipe_user_precondition: BOOLEAN is
			-- User-defined preconditions for `finalize_to_pipe'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	precompile_to_pipe_user_precondition: BOOLEAN is
			-- User-defined preconditions for `precompile_to_pipe'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_successful_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_successful'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	freezing_occurred_user_precondition: BOOLEAN is
			-- User-defined preconditions for `freezing_occurred'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	compiler_version_user_precondition: BOOLEAN is
			-- User-defined preconditions for `compiler_version'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	expand_path_user_precondition (a_path: STRING): BOOLEAN is
			-- User-defined preconditions for `expand_path'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	generate_msil_keyfile_user_precondition (filename: STRING): BOOLEAN is
			-- User-defined preconditions for `generate_msil_keyfile'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	freeze_command_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `freeze_command_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	freeze_command_arguments_user_precondition: BOOLEAN is
			-- User-defined preconditions for `freeze_command_arguments'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	has_signable_generation_user_precondition: BOOLEAN is
			-- User-defined preconditions for `has_signable_generation'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	remove_file_locks_user_precondition: BOOLEAN is
			-- User-defined preconditions for `remove_file_locks'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	output_pipe_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `output_pipe_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_output_pipe_name_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_output_pipe_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_output_piped_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_output_piped'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	can_run_user_precondition: BOOLEAN is
			-- User-defined preconditions for `can_run'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

feature -- Basic Operations

	compile is
			-- Compile.
		require
			compile_user_precondition: compile_user_precondition
		deferred

		end

	finalize is
			-- Finalize.
		require
			finalize_user_precondition: finalize_user_precondition
		deferred

		end

	precompile is
			-- Precompile.
		require
			precompile_user_precondition: precompile_user_precondition
		deferred

		end

	compile_to_pipe is
			-- Compile with piped output.
		require
			compile_to_pipe_user_precondition: compile_to_pipe_user_precondition
		deferred

		end

	finalize_to_pipe is
			-- Finalize with piped output.
		require
			finalize_to_pipe_user_precondition: finalize_to_pipe_user_precondition
		deferred

		end

	precompile_to_pipe is
			-- Precompile with piped output.
		require
			precompile_to_pipe_user_precondition: precompile_to_pipe_user_precondition
		deferred

		end

	is_successful: BOOLEAN is
			-- Was last compilation successful?
		require
			is_successful_user_precondition: is_successful_user_precondition
		deferred

		end

	freezing_occurred: BOOLEAN is
			-- Did last compile warrant a call to finish_freezing?
		require
			freezing_occurred_user_precondition: freezing_occurred_user_precondition
		deferred

		end

	compiler_version: STRING is
			-- Compiler version.
		require
			compiler_version_user_precondition: compiler_version_user_precondition
		deferred

		end

	expand_path (a_path: STRING): STRING is
			-- Takes a path and expands it using the env vars.
			-- `a_path' [in].  
		require
			expand_path_user_precondition: expand_path_user_precondition (a_path)
		deferred

		end

	generate_msil_keyfile (filename: STRING) is
			-- Generate a cyrptographic key filename.
			-- `filename' [in].  
		require
			generate_msil_keyfile_user_precondition: generate_msil_keyfile_user_precondition (filename)
		deferred

		end

	freeze_command_name: STRING is
			-- Eiffel Freeze command name
		require
			freeze_command_name_user_precondition: freeze_command_name_user_precondition
		deferred

		end

	freeze_command_arguments: STRING is
			-- Eiffel Freeze command arguments
		require
			freeze_command_arguments_user_precondition: freeze_command_arguments_user_precondition
		deferred

		end

	has_signable_generation: BOOLEAN is
			-- Is the compiler a trial version.
		require
			has_signable_generation_user_precondition: has_signable_generation_user_precondition
		deferred

		end

	remove_file_locks is
			-- Remove file locks
		require
			remove_file_locks_user_precondition: remove_file_locks_user_precondition
		deferred

		end

	output_pipe_name: STRING is
			-- Output pipe's name
		require
			output_pipe_name_user_precondition: output_pipe_name_user_precondition
		deferred

		end

	set_output_pipe_name (return_value: STRING) is
			-- Set output pipe's name
			-- `return_value' [in].  
		require
			set_output_pipe_name_user_precondition: set_output_pipe_name_user_precondition (return_value)
		deferred

		end

	is_output_piped: BOOLEAN is
			-- Is compiler output sent to pipe `output_pipe_name'
		require
			is_output_piped_user_precondition: is_output_piped_user_precondition
		deferred

		end

	can_run: BOOLEAN is
			-- Can product be run? (i.e. is it activated or was run less than 10 times)
		require
			can_run_user_precondition: can_run_user_precondition
		deferred

		end

end -- IEIFFEL_COMPILER_INTERFACE

