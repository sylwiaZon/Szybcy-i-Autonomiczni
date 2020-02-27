-module(get_handler).
-behaviour(cowboy_handler).
-compile({no_auto_import,[get/1]}).
-compile({no_auto_import,[put/2]}).
-compile({no_auto_import,[erase/1]}).
-import(persistent_term,[get/1, put/2, erase/1]).
-import(lists,[keyfind/3]).
-export([init/2, terminate/3, allowed_methods/2, content_types_accepted/2, content_types_provided/2, router/2]).
init(Req, State) -> 
    {cowboy_rest, Req, State}.

allowed_methods(Req, State) ->
    {[<<"GET">>,<<"POST">>], Req, State}.

content_types_accepted(Req, State) ->
    {[{<<"application/json">>, router}], Req, State}.

content_types_provided(Req, State) ->
    {[{<<"application/json">>, router}], Req, State}.

router(Req, State) ->
    case cowboy_req:method(Req) of
        <<"GET">> -> 
            Url = cowboy_req:parse_qs(Req),
            {_,U} = keyfind(<<"id">>, 1, Url),
            UID = list_to_integer(binary_to_list(U)),
            io:format("~p",[UID]),
            get(resultsBase) ! {UID, get, self()},
            receive
                {  resultResponse, Resp } -> 
                    Body = mochijson2:encode({struct,[{info,Resp}]}),
                    Req_ = cowboy_req:reply(200, #{
                        <<"content-type">> => <<"application/json">>
                    }, Body, Req),
                    {ok, Req_, State}
            end;
        <<"POST">> -> 
            {_, Values, _} = cowboy_req:read_body(Req),
            UID = get(uid),
            V = {mochijson2:decode(Values), UID},
            io:format("~p",[V]),
            get(fifoQueue) ! {V, put},
            erase(uid),
            if UID >= 576460752303423488 ->
                put(uid, 0);
            true ->
                put(uid, UID + 1)
            end,
            Body = mochijson2:encode({struct,[{uid,UID}]}),
            Req_ = cowboy_req:reply(200, #{
                <<"content-type">> => <<"application/json">>
            }, Body, Req),
            {ok, Req_, State}
    end.

terminate(_Reason, _Req, _State) -> ok.