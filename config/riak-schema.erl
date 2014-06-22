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
				{dynamic_field, [
						{name, "category"},
						{type, string},
						{analyzer_factory, {erlang, text_analyzers, whitespace_analyzer_factory}}
				]},

				%% name
				{dynamic_field, [
						{name, "name"},
						{type, string},
						{analyzer_factory, {erlang, text_analyzers, whitespace_analyzer_factory}}
				]},

        %% amount
        {dynamic_field, [
            {name, "amount"},
            {type, integer},
            {analyzer_factory, {erlang, text_analyzers, integer_analyzer_factory}}
        ]},

        %% date
        {dynamic_field, [
            {name, "date"},
            {type, date},
            {analyzer_factory, {erlang, text_analyzers, noop_analyzer_factory}}
        ]},

        %% Everything else is a string
        {dynamic_field, [
            {name, "*"},
            {type, string},
            {analyzer_factory, {erlang, text_analyzers, whitespace_analyzer_factory}}
        ]}
    ]
}.
