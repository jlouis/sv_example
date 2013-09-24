-module(sv_example_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    HostMatch = '_',
    RootMatch = {"/", sv_example_handler, []},
    Dispatch = cowboy_router:compile([{HostMatch, [RootMatch]}]),
    
    cowboy:start_http(sv_example_listener, 100, [{port, 8080}],
                      [{env, [{dispatch, Dispatch}]}]),
    sv_example_sup:start_link().

stop(_State) ->
    ok.


%% ----------------------------------------------------------------------
