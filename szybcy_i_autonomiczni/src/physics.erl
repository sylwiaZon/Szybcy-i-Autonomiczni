-module(physics).
-compile({no_auto_import,[get/1]}).
-import(persistent_term,[get/1]).
-export([initCalculations/2]).

startOfBrakingPosition(Acceleration,InitialVelocity,FinalVelocity,FinalPosition) -> 
   Velocity = FinalVelocity - InitialVelocity , 
   Pow = Velocity * Velocity,
   FinalPosition - Pow / (2 * Acceleration). 


reduceDistanceBy100Meters(List)->
	lists:map(fun({Limit, Distance}) -> {Limit, round(kilometersToMeters(Distance)) - 100} end, List).

kilometersToMeters(Km) ->
	Km * 1000.

kilometersPerHoursTometersPerSeconds(KmH)->
	KmH * (1000 / 3600).


addBrakingPositions([{Limit1, _},{Limit2, Distance2}|T],EmptyList) -> 
		Acc = 5,
		NewDistance = round(startOfBrakingPosition(Acc,
			kilometersPerHoursTometersPerSeconds(Limit1),
			kilometersPerHoursTometersPerSeconds(Limit2),
			Distance2)),

		NewLimit = Limit1,
		NewList = lists:append(EmptyList,[{NewLimit, NewDistance}]),
		addBrakingPositions([{Limit2, Distance2}|T],NewList);


addBrakingPositions([],List) -> lists:append(List,[]);

addBrakingPositions([{_,_}],List) -> lists:append(List,[]).



addLists(List1,List2)->
	List = List1 ++ List2,
	lists:keysort(2, List).


create( 0 ,_,_) -> [];

create( N , Limit1, Coeff) when N > 0 -> [( round(Limit1 + Coeff) )| create( N-1, (Limit1 + Coeff), Coeff) ].


getIntermediateValues([{Limit1, Distance1},{Limit2, Distance2}|T],NewList) when Distance2 - Distance1 > 100 ->
		List = countIntermediateValues({Limit1, Distance1},{Limit2, Distance2},NewList),
		getIntermediateValues([{Limit2, Distance2}|T],List);


getIntermediateValues([{_, Distance1},{Limit2, Distance2}|T],NewList) when Distance2 - Distance1 =< 100 ->
		getIntermediateValues([{Limit2, Distance2}|T],NewList);


getIntermediateValues([],L) -> lists:append(L,[]);

getIntermediateValues([{_,_}],L) -> lists:append(L,[]).



countIntermediateValues({Limit1, Distance1},{_, Distance2} , NewList)->
	N = floor((Distance2-Distance1+99)/100) -1,
	
	Distances = lists:seq(Distance1 + 100, Distance2-1 ,100),
	Limits = create(N, Limit1, 0),
	Zip = lists:zip(Limits,Distances),
	NewList++Zip.

listToTupleConverter(Input)->
	lists:map(fun(Elem) -> list_to_tuple(Elem)end, Input).

tupleToListConverter(Input)->
	lists:map(fun(Elem) -> tuple_to_list(Elem) end, Input).


getOutput(Input)->
	Reduced  = reduceDistanceBy100Meters(listToTupleConverter(Input)),
	NewLimits = addBrakingPositions(Reduced,[]),
	List = addLists(Reduced , NewLimits),
	LimitList=[{0,0}] ++ List,
    IntermediateValue = getIntermediateValues(LimitList,[]),
    AddedIntermediateValue = LimitList ++ IntermediateValue,
    Output = lists:keysort(2, AddedIntermediateValue),
    tupleToListConverter(Output).

initCalculations(Input, UID)->
	Out = getOutput(Input),
	timer:sleep(15000),
	get(currentProcesses) ! {done},
	get(resultsBase) ! {{Out, UID}, put}.
    
   
