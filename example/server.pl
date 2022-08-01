% Provide an HTTP server to make the various components available.
% To use, run
%
%     swipl server.pl

:- use_module(library(http/http_server)).

:- http_handler(/, http_reply_file('index.html', []), []).
:- http_handler('/swipl-web.js',
                http_reply_file('../dist/swipl-web.js', [ unsafe(true) ]),
                []).
:- http_handler('/dist/swipl-web.data',
                http_reply_file('../dist/swipl-web.data', [ unsafe(true) ]),
                []).
:- http_handler('/dist/swipl-web.wasm',
                http_reply_file('../dist/swipl-web.wasm', [ unsafe(true) ]),
                []).

:- initialization(server_loop, main).

server :-
    http_server([port(8080)]).

server_loop :-
    server,
    thread_get_message(quit).
