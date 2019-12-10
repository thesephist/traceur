all: run

# run pathtracer
run:
	ink traceur.ink

# run all tests under test/
check:
	ink test/vec3.ink
