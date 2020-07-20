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

` ri: refractive index `
Dielectric := ri => {
	ri: ri
	scatter: (r, rec, attenuation, scattered) => (
		attenuation := [1, 1, 1]
		eta := (rec.frontFace :: {
			true -> 1 / ri
			false -> ri
		})

		unitDir := (vec3.norm)(r.dir)
		refracted := (vec3.refract)(unitDir, rec.normal, eta)

		scattered.pos := rec.point
		scattered.dir := refracted

		true
	)
}

Glass := Dielectric(1.517)

Water := Dielectric(1.333)

Diamond := Dielectric(2.417)

Zero := Lambertian([0, 0, 0], 0.5)
