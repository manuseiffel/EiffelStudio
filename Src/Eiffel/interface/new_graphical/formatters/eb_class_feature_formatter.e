indexing
	description: "Command to display feature information concerning a compiled class."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EB_CLASS_FEATURE_FORMATTER

inherit
	EB_CLASS_CONTENT_FORMATTER
		redefine
			is_class_feature_formatter
		end

feature -- Status report

	is_class_feature_formatter: BOOLEAN is True
			-- Is current a class feature formatter?

feature{NONE} -- Implementation

	generate_result is
			-- Generate result for display
		local
			l_class: QL_CLASS
			l_domain: QL_FEATURE_DOMAIN
			l_retried: BOOLEAN
		do
			if not l_retried then
				l_class := query_class_item_from_class_c (associated_class)
				l_domain ?= l_class.wrapped_domain.new_domain (domain_generator)
				browser.update (Void, l_domain)
			else
				browser.update (Void, Void)
			end
		rescue
			l_retried := True
			retry
		end

	domain_generator: QL_DOMAIN_GENERATOR is
			-- Domain generator to generate result				
		do
			create {QL_FEATURE_DOMAIN_GENERATOR}Result
			Result.enable_fill_domain
			Result.set_criterion (criterion)
		end

	start_class: QL_CLASS is
			-- Start class
		do
		end

indexing
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
