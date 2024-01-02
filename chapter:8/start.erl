-module(start).
-export([test/1]).

start(AnAtom, Fun) ->
    case whereis(AnAtom) of
        undefined -> register(AnAtom, spawn(fun() -> Fun() end));
        _ -> io:format("Registration failed. Retry or handle the error.~n")
    end.

test(AnAtom) ->
    spawn(fun() -> start(AnAtom, fun() -> io:format("Fun~n") end) end),
    spawn(fun() -> start(AnAtom, fun() -> io:format("Fun~n") end) end).