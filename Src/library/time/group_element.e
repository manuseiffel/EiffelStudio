indexing
	description: "Invertible object with an internal + operation"
	note: "The model is that of a commutative group."
	status: "See notice at end of class";
	date: "$Date$"
	revision: "$Revision$"
	access: algebra

deferred class
	GROUP_ELEMENT

feature -- Access

	zero: like Current is
			-- Neutral element for "+" and "-"
		deferred
		ensure
			result_exists: Result /= Void
		end;

feature -- Basic operations

	infix "+" (other: like Current): like Current is
			-- Sum with `other' (commutative)
		require
			other_exists: other /= Void
		deferred
		ensure
			result_exists: Result /= Void;
			commutative: Result.is_equal (other + Current)
		end;

	infix "-" (other: like Current): like Current is
			-- Result of subtracting `other'
		require
			other_exists: other /= Void
		deferred
		ensure
			result_exists: Result /= Void
		end;

	prefix "+": like Current is
			-- Unary plus
		deferred
		ensure
			result_exists: Result /= Void;
			result_definition: Result.is_equal (Current)
		end;

	prefix "-": like Current is
			-- Unary minus
		deferred
		ensure
			result_exists: Result /= Void;
			result_definition: (Result + Current).is_equal (zero)
		end;

invariant

	neutral_addition: Current.is_equal (Current + zero);
	self_subtraction: zero.is_equal (Current - Current);

end -- class GROUP_ELEMENT


--|---------------------------------------------------------------
--| EiffelBasetemp: library of reusable components for ISE Eiffel 3.
--| Copyright (C) 1995, Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|---------------------------------------------------------------
