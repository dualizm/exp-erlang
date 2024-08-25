-module(geometry).
-export([area/1]).

area({rectangle, Width, Ht}) -> Width * Ht;
area({square, X}) -> X * X;
area({circle, R}) -> math:pi() * R * R.