-module(youtube).
-export([download/1]).
 
%download("http://www.youtube.com/watch?v=c26xcDhF2JU")

download(URL) ->
	inets:start(),
	{ok, {_, _, Body}} = httpc:request(URL),
	Url = get_url(Body), 
	io:format("URL : ~p~n", [Url]).

get_url(Body) -> 
	{match, [{Start, Length}]} = re:run(Body, "fallback_host="), 
	Url = string:substr(Body, Start+Length+1, 1000),
	{match, [{Start1, Length1}]} = re:run(Url, "url="),
	Url1 = string:substr(Url, Start1+Length1+1),
	List = string:tokens(Url1, ","), 
	FinalUrl = lists:nth(1, List),
	Req = http_uri:decode(FinalUrl),
	ReqUrl = case re:run(Req, "u0026") of 
				{match, [{S, _}]} -> string:substr(Req, 1, S-2); 
				_ -> Req 
				end,
	ReqUrl ++ "&title=mymovie".