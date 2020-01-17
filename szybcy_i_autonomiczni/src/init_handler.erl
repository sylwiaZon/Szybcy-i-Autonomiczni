-module(init_handler).
-behaviour(cowboy_handler).

-export([init/2, handle/2, terminate/3, allowed_methods/2]).

init(Req, _Opts) -> {cowboy_rest, Req, #{}}.

allowed_methods(Req, State) ->
    Methods = [<<"POST">>],
    {Methods, Req, State}.

handlePost(Req) ->
  	Body = <<"<h1>This is a response for POST</h1>">>,
		{ok, Req_} = cowboy_req:reply(200, [{<<"content-type">>, <<"application/json">>}], Body, Req),
		{ok, Req_, #{}}.

handle(Req, _) ->
  case request:method(Req) of
    post -> handlePost(Req)
  end.

terminate(_Reason, _Req, _State) -> ok.
