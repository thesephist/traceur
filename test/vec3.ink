` tests for vec3 `

std := load('../vendor/std')

log := std.log
f := std.format

` ink standard test runner `
s := (load('../vendor/suite').suite)('traceur/vec3')

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

mark('abs, abssq, norm')
(
	v := (vec3.create)(0, 3, 4)

	test('vec3.abs', (vec3.abs)(v), 5)
	test('vec3.abssq', (vec3.abssq)(v), 25)
	test('vec3.norm', (vec3.abssq)((vec3.sub)(
		(vec3.norm)(v), (vec3.create)(0, 3 / 5, 4 / 5)
	)) < 0.000001, true)
	test('vec3.norm of negative', (vec3.abssq)((vec3.sub)(
		(vec3.norm)((vec3.neg)(v)), (vec3.create)(0, ~3 / 5, ~4 / 5)
	)) < 0.000001, true)
)

mark('vec3 arithmetic')
(
	a := (vec3.create)(1, 2, 3)
	b := (vec3.create)(4, 5, 6)

	test('vec3.add'
		veq((vec3.add)(a, b), (vec3.create)(5, 7, 9)), true)
	test('vec3.sub'
		veq((vec3.sub)(b, a), (vec3.create)(3, 3, 3)), true)
	test('vec3.neg'
		veq((vec3.neg)(a), (vec3.create)(~1, ~2, ~3)), true)
	test('vec3.multiply'
		veq((vec3.multiply)(a, 3), (vec3.create)(3, 6, 9)), true)
	test('vec3.divide'
		veq((vec3.divide)(b, 2), (vec3.create)(2, 2.5, 3)), true)
)

mark('vec3.dot/cross')
(
	a := (vec3.create)(1, 2, 3)
	b := (vec3.create)(4, 5, 6)

	test('vec3.dot', (vec3.dot)(a, b), 32)
	test('vec3.cross'
		veq((vec3.cross)(a, b), (vec3.create)(~3, 6, ~3)), true)
)

mark('vec3 to other types')
(
	v := (vec3.create)(~2, 2.5, 3)

	test('vec3.list', (vec3.list)(v), [~2, 2.5, 3])
	test('vec3.string', (vec3.string)(v), '[-2, 2.50000000, 3]')
)

` print out test suite results `
(s.end)()
