` tests for vec3 `

std := load('../vendor/std')

log := std.log
f := std.format

` ink standard test runner `
s := (load('../vendor/suite').suite)('traceur/ray')

` helper functions for the test suite `
mark := s.mark
test := s.test

ray := load('../lib/ray')
ray := ray.eq

` print out test suite results `
(s.end)()
