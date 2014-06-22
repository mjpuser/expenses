{
    schema,
    [
        {version, "1.1"},
        {n_val, 3},
        {default_field, "value"},
        {analyzer_factory, {erlang, text_analyzers, whitespace_analyzer_factory}}
    ],
    [
				%% category
				{field, [
						{name, "category"},
						{type, string},
						{analyzer_factory, {erlang, text_analyzers, whitespace_analyzer_factory}}
				]},

				%% name
				{field, [
						{name, "name"},
						{type, string},
						{analyzer_factory, {erlang, text_analyzers, whitespace_analyzer_factory}}
				]},

        %% amount
        {field, [
            {name, "amount"},
            {type, integer}
	       ]},

        %% date
        {field, [
            {name, "date"},
            {type, date}
        ]},

        %% Everything else is a string
        {dynamic_field, [
            {name, "*"},
            {type, string},
            {analyzer_factory, {erlang, text_analyzers, whitespace_analyzer_factory}}
        ]}
    ]
}.
