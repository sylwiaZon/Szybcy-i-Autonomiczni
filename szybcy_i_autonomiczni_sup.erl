-module(szybcy_i_autonomiczni_sup).
-behaviour(supervisor).
-compile({no_auto_import,[get/1]}).
-compile({no_auto_import,[put/2]}).
-import(currentProcesses,[process/2]).
-import(fifoQueue,[processesQueue/1]).
-import(resultsBase,[resultsBase/1]).
-import(persistent_term,[get/1,put/2]).
-import(dict, [new/0]).
-export([start_link/0]).
-export([init/1, startProcesses/0]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Procs = [],
	startProcesses(),
	{ok, {{one_for_one, 1, 5}, Procs}}.

startProcesses() ->
    RPID = spawn (resultsBase, resultsBase, [new()]),
    FPID = spawn (fifoQueue, processesQueue, [[]]),
    CPID = spawn (currentProcesses, process, [0]),
	put(resultsBase, RPID),
	put(fifoQueue, FPID),
	put(currentProcesses, CPID),
	put(uid, 0).