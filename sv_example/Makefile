
PROJECT = sv_example

rel: clean-rel deps
	relx

clean-rel:
	rm -fr _rel

console:
	_rel/bin/sv_example console \
		-pa ../ebin

siege:
	siege \
		-c 500 \
		-t 60S \
		http://localhost:8080/
DEPS=cowboy lager safetyvalve jsx
dep_lager = http://github.com/basho/lager.git 2.0.0
dep_cowboy = pkg://cowboy master
dep_safetyvalve = http://github.com/jlouis/safetyvalve.git master
dep_jsx = http://github.com/talentdeficit/jsx.git master

include erlang.mk