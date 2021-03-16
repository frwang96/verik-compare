BSC = bsc
SOURCE = Top.bsv
MODULE = mkTop

.PHONY: all clean

all:
	rm -rf build
	mkdir -p build
	(cd src; $(BSC) -bdir ../build -vdir ../build -simdir ../build -verilog -u $(SOURCE))
	(cd src; $(BSC) -bdir ../build -vdir ../build -simdir ../build -sim -g $(MODULE) -u $(SOURCE))
	(cd src; $(BSC) -bdir ../build -vdir ../build -simdir ../build -sim -e $(MODULE) -o ../build/out)

clean:
	rm -rf build