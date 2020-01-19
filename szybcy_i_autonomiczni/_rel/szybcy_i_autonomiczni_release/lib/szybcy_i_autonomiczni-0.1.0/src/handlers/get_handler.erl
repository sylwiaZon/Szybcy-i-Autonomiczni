-module(get_handler).
-behaviour(cowboy_handler).

-export([init/2, terminate/3, allowed_methods/2]).

init(Req, State) -> 
    Body = <<"<h1>This is a response for GET</h1>">>,
    Req_ = cowboy_req:reply(200, #{
        <<"content-type">> => <<"application/json">>
    }, Body, Req),
    {ok, Req_, State}.

allowed_methods(Req, State) ->
    Methods = [<<"GET">>],
    {Methods, Req, State}.

terminate(_Reason, _Req, _State) -> ok.
