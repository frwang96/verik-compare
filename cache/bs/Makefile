BSC = $(BSC_HOME)/bsc
SOURCE = Top.bsv

.PHONY: all

all:
	rm -rf build
	mkdir -p build
	(cd src; $(BSC) -bdir ../build -vdir ../build -simdir ../build -verilog -u $(SOURCE))

clean:
	rm -rf build