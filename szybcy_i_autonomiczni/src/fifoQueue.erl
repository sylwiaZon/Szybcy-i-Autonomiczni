-module(fifoQueue).
-import(lists,[append/2,nth/2, nthtail/2]).
-export([queue/1]).

queue(Value) -> 
    receive 
        {V, put, CPID} ->
            CPID ! {V, put, self()};
        {V, nope} -> 
            queue(append(Value, [V]));
        {get, CPID} -> 
            CPID ! {nth(1,Value), put, self()},
            queue(nthtail(1,Value))
    end.    