-module(resultsBase).
-compile({no_auto_import,[get/1]}).
-compile({no_auto_import,[put/2]}).
-compile({no_auto_import,[erase/1]}).
-import(persistent_term,[get/1, put/2, erase/1]).
-import(dict, [take/2, erase/2, append/3, fetch_keys/1]).
-export([resultsBase/1]).

resultsBase(Value) -> 
    receive 
        {{V, UID}, put} ->
            Val = append(UID, V, Value),
            resultsBase(Val);
        {UID, get, RPID} -> 
            case take(UID, Value) of
                {Val, Dict} -> 
                    RPID ! { resultResponse, Val },
                    resultsBase(Dict);
                error ->    
                    RPID ! { resultResponse, "" },
                    resultsBase(Value)      
            end
    end.