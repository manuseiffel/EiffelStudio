note
	description: "Represents a float on the constant pool."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CPE_FLOAT

inherit
	CONSTANT_POOL_ELEMENT
		redefine
			close,
			emit,
			is_equal,
			out
		end
			
create
	make

feature {NONE} -- Initialisation

	make (f: REAL)
		do
			float := f
		end
			
feature -- Access

	tag_id: INTEGER = 4
	
	float: REAL

	close
		do
			create bc.make_size (Int_16_size + Float_size)
			append_tag_info (bc)
			bc.append_float_from_real (float)
			Precursor
		end
			
	emit (file: RAW_FILE)
		do
			bc.emit (file)
		end
			
	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := same_type (other) and then float = other.float
		end
			
	out: STRING
		do
			Result := "Float:" + float.out + "%N"
		end
			
feature {NONE} -- Implementation
			
	bc: JVM_BYTE_CODE

invariant
			
	closed_implies_bc_exists: is_closed implies bc /= Void

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end

