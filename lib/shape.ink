` library of basic shapes `

vec3 := load('vec3')

` shapes are designed to be "objects"
	with methods as closures that export objects
	with function references `

sphere := (pos, radius) => {
	pos: pos
	radius: radius
	hit: ray => (
		oc := (vec3.sub)(ray.pos, pos)
		a := (vec3.dot)(ray.dir, ray.dir)
		b := 2 * (vec3.dot)(oc, ray.dir)
		c := (vec3.dot)(oc, oc) - radius * radius
		discriminant := b * b - 4 * a * c
		discriminant > 0
	)
}
