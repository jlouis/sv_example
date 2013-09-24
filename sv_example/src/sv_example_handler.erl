%%% sv_example_handler implements XKCD style random values in a REST handler
%%% see http://xkcd.com/221/
-module(sv_example_handler).

%% Cowboy REST Callback API
-export([allowed_methods/2,
         content_types_provided/2,
         get_json/2,
         init/3,
         terminate/3]).

init({tcp, http}, _Req, _Opts) ->
    {upgrade, protocol, cowboy_rest}.

allowed_methods(Req, State) ->
    {[<<"GET">>], Req, State}.

content_types_provided(Req, State) ->
    {[{{<<"application">>, <<"json">>, []}, get_json}], Req, State}.

get_json(Req, State) ->
    case sv:run(web_queue, fun () -> xkcd_random() end) of %% Ask SV // HL
        {ok, RandomNum} ->
            RespBody = [{<<"Method">>, <<"XKCD-221 RNG">>},
                        {<<"Result">>, RandomNum}],
            {jsx:to_json(RespBody), Req, State};
        {error, Reason} ->
            R = atom_to_binary(Reason, utf8),
            {ok, Reply} =
              cowboy_req:reply(503, [],
                               <<"System Overloaded ", R/binary>>, Req),
            {halt, Reply, State}
    end.

terminate(_Reason, _Req, _State) ->
    ok.

%% Internal players
%% -------------------------------
xkcd_random() ->
	%% Chosen by fair dice roll
	%% Guaranteed to be random
	timer:sleep(300), % Slowed down to match Dual EC DRBG // HL
	4.
