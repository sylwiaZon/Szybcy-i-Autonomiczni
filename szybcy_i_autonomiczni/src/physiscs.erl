-module(physics).
-compile(export_all).

start_of_braking_position(Acceleration,InitialVelocity,FinalVelocity,FinalPosition) -> 
   Velocity = FinalVelocity - InitialVelocity , 
   Pow = Velocity * Velocity,
   FinalPosition - Pow / (2 * Acceleration). 


time_from_start(Time,Acceleration, InitialVelocity, FinalVelocity)->
   Time + abs(FinalVelocity - InitialVelocity) / Acceleration.

finalVelocity(Acceleration,InitialVelocity,StartPosition,EndPosition)->
    math:sqrt(2 * Acceleration *(EndPosition - StartPosition)) + InitialVelocity.

reduceAcceleration(Acceleration ,Coefficient)->
    Acceleration * Coefficient.

reduceDistanceBy100Meters(List)->
	lists:map(fun({Limit, Distance}) -> {Limit, round(kilometersToMeters(Distance)) - 100} end, List).

kilometersToMeters(Km) ->
	Km * 1000.

hoursToSeconds(H)->
	H * 3600.

kilometersPerHoursTometersPerSeconds(KmH)->
	KmH * (1000 / 3600).


step2([{Limit1, _},{Limit2, Distance2}|T],EmptyList) -> 
		Acc = 5,
		NewDistance = round(start_of_braking_position(Acc,kilometersPerHoursTometersPerSeconds(Limit1),kilometersPerHoursTometersPerSeconds(Limit2),Distance2)),
		NewLimit = Limit1,
		NewList = lists:append(EmptyList,[{NewLimit, NewDistance}]),
		step2([{Limit2, Distance2}|T],NewList);

step2([],L) -> lists:append(L,[]);

step2([{_,_}],L) -> lists:append(L,[]);

step2([{Limit1, _},{Limit2, Distance2}],L) -> 
        Acc = 5,
		NewDistance = round(start_of_braking_position(Acc,kilometersPerHoursTometersPerSeconds(Limit1),kilometersPerHoursTometersPerSeconds(Limit2),Distance2)),
		NewLimit = Limit1,
		lists:append(L,[{NewLimit, NewDistance}]).


step3(L1,L2)->
	L = L1 ++ L2,
	lists:keysort(2, L).

create( 0 ,_,_) -> [];
create( N , Limit1, Coeff) when N > 0 -> [( Limit1 + Coeff )| create( N-1, (Limit1 + Coeff), Coeff) ].



getOutput(Input) ->
	Limit = 10.0,
	Reduced  = reduceDistanceBy100Meters(Input),
	Temp = [{0,0}] ++ Reduced,
	NewPoints = step2(Temp,[]),
	List =[{0,0}] ++ step3(Reduced,NewPoints),
    LastElement = lists:nth(length(List),List),
	List ++ [erlang:setelement(2,LastElement,round(kilometersToMeters(Limit)))].

initCalculations(Body, BPID, UID) ->
   BPID ! {getOutput(Body), UID, put}.