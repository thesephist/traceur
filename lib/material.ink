` material abstraction `

vec3 := load('vec3')
ray := load('ray')

Matte := (color) => {
	color: color
	scatter: (r, rec, attenuation, scattered) => (
		scatterDir := (vec3.add)(rec.normal, (vec3.randUnitSphere)())

		scattered.pos := rec.point
		scattered.dir := scatterDir

		attenuation.0 := color.0
		attenuation.1 := color.1
		attenuation.2 := color.2
		true
	)
}

Lambertian := (color) => {
	color: color
	scatter: (r, rec, attenuation, scattered) => (
		scatterDir := (vec3.add)(rec.normal, (vec3.randUnitVec)())

		scattered.pos := rec.point
		scattered.dir := scatterDir

		attenuation.0 := color.0
		attenuation.1 := color.1
		attenuation.2 := color.2
		true
	)
}

Metal := (color, fuzz) => {
	color: color
	fuzz: fuzz
	scatter: (r, rec, attenuation, scattered) => (
		reflected := (vec3.reflect)((vec3.norm)(r.dir), rec.normal)

		scattered.pos := rec.point
		scattered.dir := (fuzz :: {
			0 -> reflected
			_ -> (vec3.add)(reflected, (vec3.multiply)((vec3.randUnitVec)(), fuzz))
		})

		attenuation.0 := color.0
		attenuation.1 := color.1
		attenuation.2 := color.2

		(vec3.dot)(scattered.dir, rec.normal) > 0
	)
}

` perfectly reflective Metal `
Mirror := color => Metal(color, 0)

Zero := Lambertian([0, 0, 0], 0.5)
