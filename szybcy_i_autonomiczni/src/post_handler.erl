-module(post_handler).
-behavior(cowboy_handler).

-export([init/2, handle/2, terminate/3]).

init(Req0, State) -> {ok, Req0, State}.

handle(Req, State) ->
	{Method, ReqM} = cowboy_req:method(Req),
	case Method of
		<<"POST">> -> 
			Body = <<"<h1>This is a response for POST</h1>">>,
            {ok, Req3} = cowboy_req:reply(200, [], Body, Req3),
            {ok, Req3, State}
	end.

terminate(Reason, Req, State) -> ok.

