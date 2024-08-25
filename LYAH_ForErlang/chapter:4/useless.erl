-module(useless).
-export([
  add/2, 
  hello/0,
  greet_and_add_two/1
]).

-import(io, [format/1]).
-define(sum(X,Y), X + Y).

add(A,B) ->
  ?sum(A, B).

%% Shows greetings
hello() ->
  format("Hello, world!~n").

greet_and_add_two(X) ->
  hello(),
  add(X,2).
