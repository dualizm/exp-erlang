-module(dist_demo).
-export([rpc/4, start/1]).

start(Node) ->
    spawn(Node, fun loop/0).

rpc(Pid, Module, Fun, Args) ->
    Pid ! {rpc, self(), Module, Fun, Args},
    receive
        {Pid, Response} ->
            Response
    end.

loop() ->
    receive
        {rpc, Pid, Module, Fun, Args} ->
            Pid ! {self(), (catch apply(Module, Fun, Args))},
            loop()
    end.