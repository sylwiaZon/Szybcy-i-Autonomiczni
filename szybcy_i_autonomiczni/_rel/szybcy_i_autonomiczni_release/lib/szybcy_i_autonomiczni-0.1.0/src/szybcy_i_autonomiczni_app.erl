-module(szybcy_i_autonomiczni_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
        {'_', [{"/postRoute", post_handler, []},{"/getRoute", get_handler, []}]}
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, 8085}],
        #{env => #{dispatch => Dispatch}}
    ),
	szybcy_i_autonomiczni_sup:start_link().

stop(_State) ->
	ok = cowboy:stop_listener(my_http_listener).
