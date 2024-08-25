-module(edemo1).
-export([start/2]).

start(Bool, M) ->
    A = spawn(fun() -> a() end),
    B = spawn(fun() -> b(A, Bool) end),
    C = spawn(fun() -> c(B, M) end),
    sleep(1_000),
    status(b, B),
    status(c, C).

a() ->
    process_flag(trap_exit, true),
    wait(a).

b(A, Bool) ->
    process_flag(trap_exit, Bool),
    link(A),
    wait(b).

c(B, M) ->
    link(B),
    case M of
        {die, Reason} ->
            exit(Reason);
        {divide, N} ->
            1/N,
            wait(c);
        normal ->
            true
    end.

wait(Prog) ->
    receive
        Any ->
            io:format("Process ~p received ~p~n", [Prog, Any]),
            wait(Prog)
    end.


sleep(Time) ->
    receive
    after Time ->
        void
    end.

status(Name, Pid) ->
    io:format("process ~p (~p) is ~p~n", [Name, Pid, fmt_status(Pid)]).

fmt_status(Pid) ->
    case erlang:is_process_alive(Pid) of 
        true -> "alive"; 
        false -> "dead" 
    end.