-module(l).
-compile(export_all).

type(V) when is_integer(V) ->
	integer;

type(V) when is_atom(V) ->
	atom;

type(V) when is_bitstring(V) ->
	bitstring;

type(V) when is_float(V) ->
	float;

type(V) when is_binary(V) ->
	binary;

type(V) when is_boolean(V) ->
	boolean;

type(V) when is_list(V) ->
	list;

type(V) when is_tuple(V) ->
	tuple;

type(V) when is_function(V) ->
	function;

type(V) when is_number(V) ->
	number;

type(V) when is_port(V) ->
	port;

type(V) when is_reference(V) ->
	reference;

type(V) when is_pid(V) ->
	pid.

a2l(V) ->
	atom_to_list(V).

a2b(V) ->
	atom_to_binary(V, latin1).

i2l(V) ->
	integer_to_list(V).

i2b(V) ->
	list_to_binary(integer_to_list(V)).

f2l(V) ->
	float_to_list(V, [{decimals, 2}]).

f2b(V) -> 
	A = float_to_list(V, [{decimals, 2}]), list_to_binary(A).

l2a(V) ->
	list_to_atom(V).

l2i(V) ->
	list_to_integer(V).

l2f(V) ->
	try
		list_to_float(V)
	catch
		_:_ -> list_to_integer(V) + 0.0
	end.

b2a(V) ->
	binary_to_atom(V, utf8).

b2i(V) ->
	binary_to_integer(V).

f2i(V) ->
	trunc(V).

l2b(V) ->
	list_to_binary(V).

b2l(V) ->
	binary_to_list(V).

b2f(V) ->
	case V of
		<<"">> -> 0.0;
		_ ->
			try
				list_to_float(binary_to_list(V))
			catch
				_:_ -> list_to_integer(binary_to_list(V)) + 0.0
			end
	end.

l2utf(V) ->
	unicode:characters_to_binary(V, unicode, utf8).

utf2l(V) ->
	unicode:characters_to_list(V, utf8).	

rtrim(B, X) when is_binary(B), is_integer(X) ->

	    S = byte_size(B),

		    do_rtrim(S, B, X);

		rtrim(B, [_|_]=Xs) when is_binary(B) ->

			    S = byte_size(B),

				do_mrtrim(S, B, Xs).

do_rtrim(0, _B, _X) ->

	    <<>>;

	do_rtrim(S, B, X) ->

		    S2 = S - 1,

			    case binary:at(B, S2) of

					        X -> do_rtrim(S2, B, X);

							        _ -> binary_part(B, 0, S)

										    end.


do_mrtrim(0, _B, _Xs) ->

	    <<>>;

	do_mrtrim(S, B, Xs) ->

		    S2 = S - 1,

			    X = binary:at(B, S2),

				    case ordsets:is_element(X, Xs) of

						        true  -> do_mrtrim(S2, B, Xs);

								        false -> binary_part(B, 0, S)

									end.


unix2win(Text) ->
	list_to_binary(unix2win_(Text)).

unix2win_(<<>>) -> [];

unix2win_(<<H/utf8, T/binary>>) ->
	S = case H of
		<<"\n">> -> <<"\n\r">>;
		V -> V
	end,
	[S|unix2win(T)].

sub(Str,Old,New) ->
	RegExp = "\\Q"++Old++"\\E",
	re:replace(Str,RegExp,New,[multiline, {return, list}]).

gsub(Str,Old,New) ->
	RegExp = "\\Q"++Old++"\\E",
	re:replace(Str,RegExp,New,[global, multiline, {return, list}]).

bsub(Str,Old,New) ->
	binary:replace(Str, Old, New, [global]).

pl_sk(K, V, List) ->
    lists:keyreplace(K, 1, List, {K, V}).

format_utc_timestamp(Offset) ->
	    TS = {_,_,Micro} = os:timestamp(),
	    {{Year,Month,Day},{Hour,Minute,Second}} =
		calendar:now_to_universal_time(TS),
	    Mstr = element(Month,{"Jan","Feb","Mar","Apr","May","Jun","Jul",
			"Aug","Sep","Oct","Nov","Dec"}),
		io_lib:format("~2w ~s ~4w ~2w:~2..0w:~2..0w",
		[Day,Mstr,Year,Hour+Offset,Minute,Second]).

current_time() ->
	{{YY,MM,DD},{H,M,S}} = calendar:gregorian_seconds_to_datetime(erlang:system_time(second)),
	{{YY+1970,MM,DD},{H,M,S}}.



