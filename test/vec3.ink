` tests for vec3 `

` ink standard test runner `
s := (load('vendor/suite').suite)('traceur/vec3')

` helper functions for the test suite `
mark := s.mark
test := s.test

vec3 := load('../lib/vec3')
veq := vec3.eq

mark('creation, getter, setter')
(
	v := (vec3.create)(10, 20, 30)

	test('can access x', v.x, 10)
	test('can access y', v.y, 20)
	test('can access z', v.z, 30)
)

mark('abs & abssq')
(
	v := (vec3.create)(0, 3, 4)

	test('abs() returns correct length', (vec3.abs)(v), 5)
	test('abssq() returns correct squared length', (vec3.abssq)(v), 25)
)

` TODO: flesh this out `

` print out test suite results `
(s.end)()
