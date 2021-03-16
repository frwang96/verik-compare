.PHONY: all test clean

all:
	sbt 'runMain alu.Main --no-dce --target-dir build'

test:
	sbt test

clean:
	rm -rf build target test_run_dir