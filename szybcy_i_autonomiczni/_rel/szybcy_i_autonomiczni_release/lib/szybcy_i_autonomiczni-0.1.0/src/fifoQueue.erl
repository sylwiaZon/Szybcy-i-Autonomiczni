-module(fifoQueue).
-compile({no_auto_import,[get/1]}).
-import(persistent_term,[get/1]).
-import(lists,[append/2,nth/2, nthtail/2]).
-export([processesQueue/1]).

processesQueue(Value) -> 
    receive 
        {V, put} ->
            io:format("NIE DZIALAM! ~p", [Value]),
            get(currentProcesses) ! {V, put},
            io:format("NIE DZIALAM BARDZO! ~p", [Value]),
            processesQueue(Value);
        {V, nope} -> 
            processesQueue(append(Value, [V]));
        {get} -> 
            get(currentProcesses) ! {nth(1,Value), put},
            processesQueue(nthtail(1,Value))
    end.    