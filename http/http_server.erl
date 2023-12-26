-module(http_server).
-export([start/0, start/1]).

-record(request, {
    method  = undef,
    path    = undef,
    version = undef,
    headers = #{}
}).

parse_request(Sock) -> parse_request(Sock, #request{}).

parse_request(Sock, Req) ->
    case gen_tcp:recv(Sock, 0) of
        {ok, {http_request, Method, {abs_path, Path}, Ver}} ->
            Req1 = Req#request{method = Method,
                path = Path, 
                version = Ver},
            parse_request(Sock, Req1);
        {ok, {http_request, _, Name, _, Value}} ->
            Headers = Req#request.headers,
            Headers1 = Headers#{Name => Value},
            Req1 = Req#request{headers = Headers1},
            parse_request(Sock, Req1);
        {ok, http_eoh} -> {ok, Req};
        {ok, {http_error, Error}} -> {error, Error};
        {error, closed} -> ignore;
        {error, Error} -> {error, Error};
        Data -> {error, Data}
    end.

random_phrase() ->
    Number = rand:uniform(21),
    if
        Number < 8 -> "Greetings from Erlang!";
        Number < 14 -> "Yep.. That's Erlang!";
        Number < 21 -> "Erlang is cool!";
        true -> "Whaaaat"
    end.

handle_request(Sock) ->
    case parse_request(Sock) of
        ignore -> close;
        {ok, #request{path = Path, headers = #{'Connection' := Conn}}} 
            when Conn =:= "keep-alive";
                 Conn =:= "Keep-Alive" ->
            Body = [random_phrase(), " on ", Path],
            CLen = iolist_size(Body),
            gen_tcp:send(Sock, 
                [
                    "HTTP/1.0 200 OK\r\n",
                    "Access-Control-Allow-Origin: *\r\n",
                    "Connection: keep-alive\r\n",
                    "Content-Type: text/plain\r\n",
                    ["Content-Length: ", integer_to_list(CLen)],
                    "\r\n\r\n",
                    Body
                ]),
            loop;
        {ok, #request{path = Path}} ->
            gen_tcp:send(Sock, [
                "HTTP/1.0 200 OK\r\n",
                "Access-Control-Allow-Origin: *\r\n",
                "Content-Type: text/plain",
                "\r\n\r\n",
                random_phrase(), " on ", Path
            ]),
            close;
        {error, Error} ->
            io:format("Error: ~p~n", [Error]),
            gen_tcp:send(Sock, [
                <<"HTTP/1.0 500 Internal Error\r\n">>,
                <<"Access-Control-Allow-Origin: *\r\n">>,
                <<"Content-Type: text/plain">>,
                <<"\r\n\r\n">>,
                Error,
                random_phrase()
            ]),
            close
    end.

accept_loop(LSock) ->
    {ok, Sock} = gen_tcp:accept(LSock),
    handle_loop(Sock),
    accept_loop(LSock).

handle_loop(Sock) ->
    case handle_request(Sock) of
        loop -> handle_loop(Sock);
        close -> gen_tcp:close(Sock)
    end.

start() -> start(8080).
start(Port) ->
    Opts = [{packet, http},
            {active, false},
            {backlog, 1024}],
    {ok, LSock} = gen_tcp:listen(Port, Opts),
    accept_loop(LSock).