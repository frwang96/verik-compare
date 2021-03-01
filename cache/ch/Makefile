.PHONY: all clean

all:
	sbt 'runMain cache.Main --no-dce --target-dir build'

clean:
	rm -rf build target test_run_dir