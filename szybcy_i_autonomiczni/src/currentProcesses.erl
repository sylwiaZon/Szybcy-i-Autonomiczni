-module(currentProcesses).
-import(physics,[initCalculations/2]).
-export([process/2]).

process(Counter, BPID) ->
    receive
        {V, put, QPID} ->
            if 
                Counter < 5 ->
                    spawn(physics, initCalculations, [V, BPID]),
                    process(Counter + 1, BPID);
                Counter >= 5 ->
                    QPID ! {V, nope}
            end;
        {done, QPID} -> 
            QPID ! {get, self()},
            process(Counter - 1, BPID)
    end.
