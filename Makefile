all: run

# run pathtracer
run:
	./traceur.ink

# run all tests under test/
check:
	./test.ink

fmt:
	inkfmt fix lib/*.ink test/*.ink ./*.ink

fmt-check:
	inkfmt lib/*.ink test/*.ink ./*.ink
