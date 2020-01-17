{application, 'szybcy_i_autonomiczni', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['init_handler','szybcy_i_autonomiczni_app','szybcy_i_autonomiczni_sup']},
	{registered, [szybcy_i_autonomiczni_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {szybcy_i_autonomiczni_app, []}},
	{env, []}
]}.