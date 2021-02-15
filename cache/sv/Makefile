XVLOG = xvlog
XELAB = xelab
XSIM = xsim

SOURCES = CacheTypes.sv Cache.sv CacheTb.sv Mem.sv MemBus.sv Top.sv
TOP = Top

.PHONY: build run

build:
	mkdir -p build
	(cd build; $(foreach SOURCE, $(SOURCES), $(XVLOG) -sv ../src/$(SOURCE);))
	(cd build; $(XELAB) -debug typical $(TOP) -s sim)

run:
	(cd build; $(XSIM) -R sim)