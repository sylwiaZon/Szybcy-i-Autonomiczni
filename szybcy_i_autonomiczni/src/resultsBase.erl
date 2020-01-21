-module(resultsBase).
-import(dict, [take/2, erase/2, append/3]).
-export([resultsBase/1]).

resultsBase(Value) -> 
    receive 
        {V, UID, put} ->
            resultsBase(append(UID, V, Value));
        {UID, get} -> 
            processGet(Value, UID);
        {changeBase, V} -> 
            resultsBase(V)
        end.
            

processGet(Value, UID, RPID) -> 
    try take(UID, Value) of
        RPID ! {changeBase, deleteFromBase(Value, UID)},
        Val -> Val
    catch 
        <<"Try again later">>
    end.      

deleteFromBase(Value, UID) -> 
    erase(UID, Value).
