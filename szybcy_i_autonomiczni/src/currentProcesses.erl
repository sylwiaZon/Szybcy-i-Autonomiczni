-module(currentProcesses).
-compile({no_auto_import,[get/1]}).
-import(persistent_term,[get/1]).
-import(physics,[initCalculations/2]).
-export([process/1]).

process(Counter) ->
    receive
        {{V, UID}, put} ->
            if 
                Counter < 5 ->
                    spawn(physics, initCalculations, [V, UID]),
                    process(Counter + 1);
                Counter >= 5 ->
                    get(fifoQueue) ! {{V, UID}, nope},
                    process(Counter);
                true ->
                    process(Counter)
            end;
        {done} -> 
            get(fifoQueue) ! {get},
            process(Counter - 1)
    end.