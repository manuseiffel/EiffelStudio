indexing

	description: 
		"Run time value representing of a special object.";
	date: "$Date$";
	revision: "$Revision $"

class SPECIAL_VALUE

inherit

	ABSTRACT_SPECIAL_VALUE
		redefine
			set_hector_addr
		end;

	OBJECT_ADDR
		export
			{NONE} all
		undefine
			is_equal
		end;

	CHARACTER_ROUTINES
		export
			{NONE} all	
		undefine
			is_equal
		end;

create {DEBUG_VALUE_EXPORTER}

	make_attribute

feature {NONE} -- Initialization

	make_attribute (attr_name: like name; a_class: like e_class; 
						addr: like address; cap: like capacity) is
		require
			not_attr_name_void: attr_name /= Void;
			not_addr_void: addr /= Void
		do
			name := attr_name;
			if a_class /= Void then
				e_class := a_class;
				is_attribute := True;
			end;
			address := addr;
			is_null := (address = Void)
			capacity := cap;
			reset_items
				--| No need to preallocate area, since the fill_items or similar
				--| will change the capacity if needed
				--| We require only to get a non Void list
		end

feature -- Access

	dynamic_class: CLASS_C is
		once
			Result := Eiffel_system.special_class.compiled_class
		end;

	string_value: STRING is
			-- If `Current' represents a string then return its value.
			-- Else return Void.
		local
			char_value: CHARACTER_VALUE
		do
			if items.count /= 0 then
				char_value ?= items.first
				if char_value /= Void then
					create Result.make (items.count + 8)
					if sp_lower > 0 then
						Result.append ("...")
					end
					Result.append_character ('%"')
					Result.append (eiffel_string (raw_string_value))
					Result.append_character ('%"')
					if sp_upper <= capacity - 1 then
						Result.append ("...")
					end
				end
			end
		end

	truncated_raw_string_value (a_size: INTEGER): STRING is
			-- If `Current' represents a string then return its value truncated to `a_size'.
			-- Else return Void.
			-- Do not convert special characters to an Eiffel representation.
		local
			char_value: CHARACTER_VALUE
			l_cursor: DS_LINEAR_CURSOR [ABSTRACT_DEBUG_VALUE]
		do
			if items.count /= 0 then
				char_value ?= items.first
				if char_value /= Void then
					create Result.make (a_size.min (items.count + 1))
					from
						l_cursor := items.new_cursor
						l_cursor.start
					until
						l_cursor.after or Result.count = a_size
					loop
						char_value ?= l_cursor.item
						Result.append_character (char_value.value)
						l_cursor.forth
					end;
				end
			end
			if Result = Void then
				Result := ""
			end
		ensure
			raw_string_value_not_void: Result /= Void
		end
		
	raw_string_value: STRING is
			-- If `Current' represents a string then return its value.
			-- Else return Void.
			-- Do not convert special characters to an Eiffel representation.
		local
			char_value: CHARACTER_VALUE
			l_cursor: DS_LINEAR_CURSOR [ABSTRACT_DEBUG_VALUE]
		do
			if items.count /= 0 then
				char_value ?= items.first
				if char_value /= Void then
					create Result.make (items.count + 4)
					from
						l_cursor := items.new_cursor
						l_cursor.start
					until
						l_cursor.after
					loop
						char_value ?= l_cursor.item
						Result.append_character (char_value.value)
						l_cursor.forth
					end;
				end
			end
			if Result = Void then
				Result := ""
			end
		ensure
			raw_string_value_not_void: Result /= Void
		end

	dump_value: DUMP_VALUE is
			-- Dump_value corresponding to `Current'.
		do
			create Result.make_object (address, dynamic_class)
		end

feature {ABSTRACT_DEBUG_VALUE} -- Output

	append_type_and_value (st: STRUCTURED_TEXT) is
		local
			ec: CLASS_C
		do
			if address = Void then
				st.add_string (NONE_representation)
			else
				ec := dynamic_class;
				if ec /= Void then
					ec.append_name (st);
					st.add_string (Left_address_delim);
					if Application.is_running and Application.is_stopped then
						st.add_address (address, name, ec)
					else
						st.add_string (address)
					end;
					st.add_string (Right_address_delim);
				else
					Any_class.append_name (st);
					st.add_string (Is_unknown)
				end
			end
		end;

feature {NONE} -- Output

	append_value (st: STRUCTURED_TEXT) is
			-- Append `Current' to `st' with `indent' tabs the left margin.
		local
			is_special_of_char: BOOLEAN
			char_value: CHARACTER_VALUE
			l_cursor: DS_LINEAR_CURSOR [ABSTRACT_DEBUG_VALUE]
		do
			st.add_string ("-- begin special object --");
			st.add_new_line;
			if sp_lower > 0 then
				append_tabs (st, 1);
				st.add_string ("... Items skipped ...");
				st.add_new_line
			end
			l_cursor := items.new_cursor
			if items.count /= 0 then
				l_cursor.start
				char_value ?= l_cursor.item
				is_special_of_char := char_value /= Void
			end 
			if not is_special_of_char then
				from
					l_cursor.start
				until
					l_cursor.after
				loop
					l_cursor.item.append_to (st, 1);
					l_cursor.forth
				end;
			else
				st.add_string ("%"")
				from
					l_cursor.start
				until
					l_cursor.after
				loop
					char_value ?= l_cursor.item
					check
						valid_character_element: char_value /= Void
					end
					st.add_char (char_value.value)
					l_cursor.forth
				end;
				st.add_string ("%"%N")
			end
			if 0 <= sp_upper and sp_upper < capacity - 1 then
				append_tabs (st, 1);
				st.add_string ("... More items ...");
				st.add_new_line
			end;
			st.add_string ("-- end special object --");
			st.add_new_line
		end;

feature -- Output

	children: DS_LIST [ABSTRACT_DEBUG_VALUE] is
			-- List of all sub-items of `Current'. May be void if there are no children.
			-- Generated on demand.
		do
			Result := items
		end

feature {NONE} -- Implementation
	
	set_hector_addr is
			-- Convert the physical addresses received from the application
			-- to hector addresses. (should be called only once just after
			-- all the information has been received from the application.)
		local
			l_cursor: DS_LINEAR_CURSOR [ABSTRACT_DEBUG_VALUE]
		do
			address := hector_addr (address);
			is_null := (address = Void)
			from
				l_cursor := items.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_cursor.item.set_hector_addr;
				l_cursor.forth
			end
		end;

invariant
 
	items_exists: items /= Void;
	address_not_void: address /= Void;
	is_attribute: is_attribute

end -- class SPECIAL_VALUE
