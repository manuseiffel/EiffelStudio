-- Byte code for a routine.

deferred class BYTE_CODE 

inherit

	IDABLE
		rename
			id as byte_id
		export
			{NONE} all
		end;
	BYTE_NODE
		redefine
			make_byte_code, enlarge_tree
		end;
	SHARED_ENCODER;
	SHARED_C_LEVEL;
	SHARED_PATTERN_TABLE;
	ASSERT_TYPE;

feature 

	byte_id: INTEGER;
			-- Id of byte code

	set_byte_id (i: INTEGER) is
			-- Assign `i' to `byte_id'.
		do
			byte_id := i;
		end;

	feature_name: STRING;
			-- Name of the feature to which the current byte code tree
			-- belongs to

	body_index: INTEGER;
			-- Feature body index

	rout_id: INTEGER;
			-- Routine id of the feature

	pattern_id: INTEGER;
			-- Pattern id of the feature

	-- The corresponding C name of the generated feature in the concatenation
	-- of the body id (which is the id for the byte code server) and of
	-- the current type id in final mode only. for the workbench mode, we
	-- used the feature id instead of the body id.

	arguments: ARRAY [TYPE_I];
			-- List of argument types of the feature: can be Void

	result_type: TYPE_I;
			-- Result type of the feature: can be Void.

	locals: ARRAY [TYPE_I];
			-- List of local types of the feature: can be Void.

	precondition: BYTE_LIST [BYTE_NODE];
			-- List of ASSERT_B instances: can be Void.

	postcondition: BYTE_LIST [BYTE_NODE];
			-- List of ASSERT_B instances: can be Void.

	old_expressions: LINKED_LIST [UN_OLD_B];
			-- List of UN_OLD_B instances: can be Void.

	rescue_clause: BYTE_LIST [BYTE_NODE];
			-- List of INSTR_B instances: can be Void.

	clear_old_expressions is
			-- Clear old_expressions
		require
			valid_old_exp: old_expressions /= Void
		do
			old_expressions.wipe_out
		end;

	compound: BYTE_LIST [BYTE_NODE] is
			-- Compound byte code
		do
			-- Do nothing: to be redefined in STD_BYTE_CODE
		end; -- compound

	is_once: BOOLEAN is
			-- Is the current byte code relative to a once feature ?
		do
			-- Do nothing
		end;

	is_external: BOOLEAN is
			-- Is the current byte code relative to an external feature ?
		do
			-- Do nothing
		end;

	is_deferred: BOOLEAN is
			-- Is the current byte code relative to a deferred feature ?
		do
			-- Do nothing
		end;

	body_id: INTEGER is
			-- Body id to the associated feature
		do
			Result := System.body_index_table.item (body_index);
		end;

	set_feature_name (s: STRING) is
			-- Assign `s' to `feature_name'.
		do
			feature_name := s;
		end;

	set_body_index (i: INTEGER) is
			-- Assign `i' to `body_index'.
		do
			body_index := i;
		end;

	set_rout_id (i: INTEGER) is
			-- Assign `i' to `rout_id'.
		do
			rout_id := i;
		end;

	set_pattern_id (i: INTEGER) is
			-- Assign `i' to `pattern_id'.
		do
			pattern_id := i;
		end;

	set_result_type (t: TYPE_I) is
			-- Assign `t' to `result_type'.
		do
			result_type := t;
		end;

	set_precondition (var: like precondition) is
			-- Assign `var' to `precondition'.
		do
			precondition := var
		end;

	set_postcondition (var: like postcondition) is
			-- Assign `var' to `postcondition'.
		do
			postcondition := var
		end;

	set_old_expressions (var: like old_expressions) is
			-- Assign `var' to old_expressions.
		require
			exp_not_empty: (var /= Void) implies not var.empty
		do
			old_expressions := var
		end;

	set_rescue_clause (var: like rescue_clause) is
			-- Assign `var' to `rescue_clause'.
		do
			rescue_clause := var
		end;

	set_arguments (a: like arguments) is
			-- Assing `a' to `arguments'.
		do
			arguments := a
		end;

	set_locals (l: like locals) is
			-- Assign `l' to `locals'.
		do
			locals := l;
		end;

	enlarge_tree is
			-- Enlarges byte code tree for C code generation
		local
			item: UN_OLD_B;
			inh_assert: INHERITED_ASSERTION
		do
			inh_assert := Context.inherited_assertion;
			if inh_assert.has_assertion then
				inh_assert.enlarge_tree;
			end;
			if precondition /= Void then
				Context.set_assertion_type (In_precondition);
				precondition.enlarge_tree;
				Context.set_assertion_type (0);
			end;
			if compound /= Void then
				compound.enlarge_tree;
			end;
			if old_expressions /= Void then
				--! Wipe out old expression and rebuild
				--! it with enlarged function through 
				--! postconditions enlargement.
				--! (Look at enlarged in class UN_OLD_B)
				old_expressions.wipe_out;
			end;
			if postcondition /= Void then
				postcondition.enlarge_tree;
			end;
			if rescue_clause /= Void then
				rescue_clause.enlarge_tree;
			end;
		end;

	feature_origin: INTEGER is
			-- Value of the dynamic type where the feature is written
		do
			Result := context.class_type.type_id - 1;
		end;

	generate_arguments is
			-- Generate C arguments, if any, in the definition.
		local
			i, count: INTEGER;
		do
			generated_file.putstring ("Current");
			if arguments /= Void then
				from
					i := arguments.lower;
					count := arguments.count;
				until
					i > count
				loop
					generated_file.putstring (", ");
					generated_file.putstring ("arg");
					generated_file.putint (i);
					i := i + 1;
				end;
			end;
		end;

	generate_arg_declarations is
			-- Declare C parameters, if any, as part of the definition.
		local
			arg: TYPE_I;
			i, count: INTEGER;
			exp_arg: ARGUMENT_BL;
		do
			generated_file.putstring ("char *Current;");
			generated_file.new_line;
			if arguments /= Void then
				from
					i := arguments.lower;
					count := arguments.count;
				until
					i > count
				loop
					arg := real_type (arguments.item (i));
					arg.c_type.generate (generated_file);
					generated_file.putstring ("arg");
					generated_file.putint (i);
					generated_file.putchar (';');
					if arg.is_expanded then
						context.inc_exp_args;
							-- Force inclusion in GC hooks.
						context.force_gc_hooks;
						context.Arg_var.set_position (i);
						context.set_local_index (context.Arg_var.register_name,
							context.Arg_var.enlarged);
					end;
					generated_file.new_line;
					i := i + 1;
				end;
			end;
		end;

	finish_compound is
			-- Generate the end of the compound
		do
			-- Do nothing
		end;

	generate_old_variables is
			-- Generate value for old variables
		local
			workbench_mode: BOOLEAN;
			list_old_expr: LINKED_LIST [like old_expressions];
			old_expr: like old_expressions;
			temp_type: CL_TYPE_I;
			temp_class_type: CLASS_TYPE;
			inh_assert: INHERITED_ASSERTION;
			item: UN_OLD_BL;
		do
			workbench_mode:= Context.workbench_mode;
			inh_assert := Context.inherited_assertion;
			if Context.has_postcondition and then (old_expressions /= Void
				or else inh_assert.has_old_expression)
			then
				if workbench_mode then
					generated_file.putstring ("if (RTAL & CK_ENSURE) {");
					generated_file.new_line;
					generated_file.indent;
				else
					generated_file.putstring ("if (~in_assertion) {");					
					generated_file.new_line;
					generated_file.indent;
				end;
				if old_expressions /= Void then
					from
						old_expressions.start;
					until
						old_expressions.after
					loop
						item ?= old_expressions.item;
						item.initialize; -- Cannot fail
						old_expressions.forth;
					end;
				end;
				if inh_assert.has_old_expression then
						-- Generate old assertions
					inh_assert.generate_old_variables;
				end;

				if workbench_mode then
					generated_file.exdent;
					generated_file.putchar ('}');
					generated_file.new_line;
				else
					generated_file.exdent;
					generated_file.putchar ('}');
					generated_file.new_line;
				end;
			end;
		end;

feature -- Inherited Assertions

	formulate_inherited_assertions (assert_id_set: ASSERT_ID_SET) is
			-- Formulate inherited post and pre conditions
			-- from the precursor definition of feature `feat'
			-- and save the details in inherited_assertion.
		require
			valid_arg: assert_id_set /= Void;
			current_not_basic: not Context.associated_class.is_basic;
		local
			byte_code: BYTE_CODE;
			inh_f: INH_ASSERT_INFO;
			ct: CLASS_TYPE;
			inh_c: CLASS_C;
			bd_id, i: INTEGER;
		do
			from
				i := 1;
			until
				i > assert_id_set.count
			loop
				inh_f := assert_id_set.item (i);
				if inh_f.has_assertion then
					--! Has assertion
					inh_c := System.class_of_id (inh_f.written_in);
					if inh_c.generics = Void then
						ct := inh_c.types.first;
					else
						ct := inh_c.meta_type (Context.current_type).associated_class_type;
					end;
					bd_id := System.body_index_table.item (inh_f.body_index);
					byte_code := System.byte_server.item (bd_id);
					if inh_f.has_precondition then
						Context.inherited_assertion.add_precondition_type (ct, byte_code);
					end;
					if inh_f.has_postcondition then
						Context.inherited_assertion.add_postcondition_type (ct, byte_code);
					end;
				end;
				i := i + 1;
			end;
		end;

feature -- Byte code generation

	make_byte_code (ba: BYTE_ARRAY) is
			-- Generate byte code
		require else
			not_external: not is_external;
			valid_class_type: Context.class_type /= Void;
		local
			i, nb: INTEGER;
			r_type, formal_type: TYPE_I;	
			local_list: LINKED_LIST [TYPE_I];
			bit_i: BIT_I;
			expanded_type: CL_TYPE_I;
			inh_assert: INHERITED_ASSERTION;
			feat: FEATURE_I;
		do
			feat := Context.associated_class.feature_table.item (feature_name);
			inh_assert := Context.inherited_assertion;
			inh_assert.init;
			if  Context.has_inherited_assertion and then
				not Context.associated_class.is_basic and then
				feat.assert_id_set /= Void 
			then
					--! Do not get inherited pre & post for basic types
				formulate_inherited_assertions (feat.assert_id_set);
			end;

			Temp_byte_code_array.clear;
			
				-- Header for debuggable byte code.
			if context.debug_mode then
				Temp_byte_code_array.append (Bc_debuggable);
				Temp_byte_code_array.append_integer (body_id);	
			else
				Temp_byte_code_array.append (Bc_start);
			end;

				-- Routine id
			Temp_byte_code_array.append_integer (rout_id);

				-- Result SK value
			r_type := context.real_type(result_type);
			Temp_byte_code_array.append_integer (r_type.sk_value);

				-- Argument number
			Temp_byte_code_array.append_short_integer (argument_count);

				-- Once mark
			if is_once then
				Temp_byte_code_array.append ('%/001/');
					-- Once not done
				Temp_byte_code_array.append ('%U');
					-- Allocate space for storeing a result instance in
					-- the byte code itself
				Temp_byte_code_array.allocate_space (r_type);
			else
				Temp_byte_code_array.append ('%U');
			end;

				-- Set up the local variables
			setup_local_variables;

				-- Feature name
			ba.append_raw_string (feature_name);

				-- Dynamic type where the feature is written in
			ba.append_short_integer (context.current_type.type_id - 1);

				-- Resue offset if any.
			if rescue_clause /= Void then
				ba.append ('%/001/');
				ba.mark_forward;
			else
				ba.append ('%U');
			end;

				-- Record retry offset
			ba.mark_retry;

				-- Compound byte code
			make_body_code (ba);

			ba.append (Bc_null);

			if rescue_clause /= Void then
				ba.write_forward;
				ba.append (Bc_rescue);
				rescue_clause.make_byte_code (ba);
				ba.append (Bc_end_rescue);
			end;

			from
				local_list := context.local_list;
				Temp_byte_code_array.append_short_integer (local_list.count);
				local_list.start
			until
				local_list.after
			loop
				Temp_byte_code_array.append_integer (local_list.item.sk_value);
				local_list.forth;
			end;

				-- Expanded Clone
			if arguments /= Void then
				from
					i := 1;
					nb := arguments.count;
				until
					i > nb
				loop
					formal_type := context.real_type (arguments.item (i));
					if formal_type.is_expanded or else formal_type.is_bit
					then
						Temp_byte_code_array.append (Bc_clone_arg);
						Temp_byte_code_array.append_short_integer (i);
						if formal_type.is_bit then
							bit_i ?= formal_type;
							Temp_byte_code_array.append_short_integer
															(bit_i.size);
						else
							expanded_type ?= formal_type;
							Temp_byte_code_array.append_short_integer
										(expanded_type.expanded_type_id - 1);
						end;
					end;
					i := i + 1;
				end;
			end;
			Temp_byte_code_array.append (Bc_no_clone_arg);

			context.byte_prepend (ba, Temp_byte_code_array);

				-- Clean the context
			local_list.wipe_out;
			inh_assert.wipe_out;
		end;

	setup_local_variables is
			-- Set the local variable type (which includes old expressions)
			-- for the interpreter.
		local
			nb, i, position: INTEGER;
			item: UN_OLD_B
		do
			from
				position := 1;
				nb := local_count;
			until
				position > nb
			loop
					-- Local SK value
				Context.add_local 
						(context.real_type (locals.item (position)));
				position := position + 1;
			end;
			if old_expressions /= Void then
				from
					nb := old_expressions.count;
					i := i
				until
					i > nb
				loop
					item := old_expressions.item;
					Context.add_local
						(context.real_type (item.type));
					item.set_position (position);
					old_expressions.forth;
					i := i + 1;
				end;
			end;
			Context.inherited_assertion.setup_local_variables (position);
		end;

	make_body_code (ba: BYTE_ARRAY) is
			-- Generate compound byte code
		require
			good_argument: ba /= Void
		deferred
		end;

	argument_count: INTEGER is
			-- Number of formal arguments
		do
			if arguments /= Void then
				Result := arguments.count;
			end;
		end;

	local_count: INTEGER is
			-- Number of local variables
		do
			if locals /= Void then
				Result := locals.count;
			end;
		end;

	Temp_byte_code_array: BYTE_ARRAY is
			-- Temporary byte code array
		once
			!!Result.make
		end;

end
