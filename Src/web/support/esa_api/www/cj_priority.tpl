<"collection": <
    "version": "1.0",
     "href": "{$host/}/priority", 
    "links": [
            <
                "href": "{$host/}",
                "rel": "home",
                "prompt": "Home"
            >,
             <
                "href": "{$host/}/reports",
                "rel": "collection",
                "prompt": "Reports"
            >,
            {if isset="$user"}
                <
                    "href": "{$host/}/user_reports/{$user/}",
                    "rel": "author",
                    "prompt": "My Reports"
                >,
                 <
                    "href": "{$host/}/report_form",
                    "rel": "create-form",
                    "prompt": "Report a Problem"
                >,
                <
                    "href": "{$host/}/logoff",
                    "rel": "logoff",
                    "prompt": "Logoff"
                >,
            {/if}
            {unless isset="$user"}
                <
                    "href": "{$host/}/login",
                    "rel": "login",
                    "prompt": "Login"
                >,
                <
                    "href": "{$host/}/register",
                    "rel": "register",
                    "prompt": "Register"
                >,
            {/unless}    
            <
                "href": "http://alps.io/iana/relations.xml",
                "rel": "profile"
            >
          ],
        "items": [
               {foreach from="$priorities" item="item"}
               <
                "href": "{$host/}/priority/{$item.id/}",
                "data": [
                    <
                        "name": "Id",
                        "prompt": "Id",
                        "value": "{$item.id/}"
                    >,
                    <
                        "name": "priority",
                        "prompt": "priority",
                        "value": "{$item.synopsis/}"
                    >
                  ]
                >,{/foreach}]                      
    >
>