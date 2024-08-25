-module(ring_test).
-export([start/3]).

start(N, M, Msg) ->
    Processes = [spawn(fun() -> proc() end) || _ <- lists:seq(1, N)],
    Linked = lists:append(Processes, [hd(Processes)]),
    {Time, _} = timer:tc(fun send_message/2, [{Msg, M}, Linked]),
    io:format("*Time execution: ~p*~n", [Time / 1_000]).

proc() ->
    receive
        {stop, [NextPid | RestPids]} ->
            NextPid ! {stop, RestPids};
        {Msg, NumMsgs, [NextPid | RestPids]} ->
            NextPid ! {Msg, NumMsgs, RestPids},
            proc()
    end.

send_message({_, 0}, [NextPid | RestPids]) -> NextPid ! {stop, RestPids};
send_message({Msg, M}, [NextPid | RestPids] = Pids) ->
    NextPid ! {Msg, M, RestPids},
    send_message({Msg, M - 1}, Pids).
