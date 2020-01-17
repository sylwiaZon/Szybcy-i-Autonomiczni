-module(init_handler).
-behaviour(cowboy_handler).

-export([init/2, handle/2, terminate/3, allowed_methods/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(200, #{
        <<"content-type">> => <<"text/plain">>
    }, <<"Hello World!">>, Req0),
    {ok, Req, State}.

allowed_methods(Req, State) ->
    Methods = [<<"POST">>],
    {Methods, Req, State}.

handlePost(Req) ->
  	Body = <<"<h1>This is a response for POST</h1>">>,
		{ok, Req_} = cowboy_req:reply(200, [{<<"content-type">>, <<"application/json">>,<<"text/html">>,<<"text/plain">>}], Body, Req),
		{ok, Req_, #{}}.

handle(Req, _) ->
  case request:method(Req) of
    post -> handlePost(Req)
  end.

terminate(_Reason, _Req, _State) -> ok.
