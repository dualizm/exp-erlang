-module(ring_test).
-export([start/1]).

start(N) ->
    Pid = spawn(fun() -> ring(N, self()) end),
    Pid ! {start, self()}.

ring(0, FirstPid) ->
    FirstPid ! {done, self()};

ring(N, PrevPid) ->
    NextPid = spawn(fun() -> ring(N - 1, PrevPid) end),
    PrevPid ! {next, NextPid},
    receive
        {start, StartPid} -> StartPid ! {next, NextPid}
    end.