-module(http_server).
-export([start/0, start/1, stop/1]).

start() -> start(8080).

start(Port) -> spawn(fun() -> init_loop(Port) end).

init_loop(Port) ->
    Opts = [{packet, http},
            {active, false},
            {backlog, 1024}],
    {ok, LSock} = gen_tcp:listen(Port, Opts),
    Pid = spawn(fun() -> handle_loop(LSock) end),
    receive
        close -> exit(Pid, ok)
    end.

handle_loop(LSock) ->
    {ok, Sock} = gen_tcp:accept(LSock),
    gen_tcp:recv(Sock, 0),
    gen_tcp:send(Sock, 
        [format_header("HTTP/1.0 200 OK")
        ,format_headers([{"Access-Control-Allow-Origin", "*"}])
        ,format_body(random_phrase())]),
    gen_tcp:close(Sock),
    handle_loop(LSock).

stop(Pid) -> Pid ! close.

format_header(Header) ->
    [Header, "\r\n"].

format_headers(Headers) ->
    [[Key, ": ", Value, "\r\n"] || {Key, Value} <- Headers].

format_body(Body) ->
    ["\r\n", Body].

random_phrase() ->
    Number = rand:uniform(21),
    if
        Number < 8 -> "Greetings from Erlang!";
        Number < 14 -> "Yep.. That's Erlang!";
        Number < 21 -> "Erlang is cool!";
        true -> "Whaaaat"
    end.