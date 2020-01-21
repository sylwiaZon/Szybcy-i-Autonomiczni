-module(resultsBase).
-import(dict, [take/2, erase/2, append/3]).
-export([resultsBase/1, processGet/3, deleteFromBase/4]).

resultsBase(Value) -> 
    receive 
        {V, UID, put} ->
            resultsBase(append(UID, V, Value));
        {UID, get} -> 
            processGet(Value, UID, self());
        {changeBase, V} -> 
            resultsBase(V)
        end.
            

processGet(Value, UID, RPID) -> 
    try
        Val =  take(UID, Value),
        deleteFromBase(Val, Value, UID, RPID)
    catch
       exit:_ -> <<"Try again later">>
    end.
       

deleteFromBase(Val, Value, UID, RPID) -> 
    RPID ! {changeBase, erase(UID, Value)},
    Val.

