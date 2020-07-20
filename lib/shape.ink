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
		a := (vec3.abssq)(ray.dir)
		halfB := (vec3.dot)(oc, ray.dir)
		c := (vec3.abssq)(oc) - radius * radius
		discriminant := halfB * halfB - a * c
		discriminant < 0 :: {
			true -> ~1
			false -> (~halfB - pow(discriminant, 0.5)) / a
		}
	)
}
