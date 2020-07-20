` material abstraction `

vec3 := load('vec3')
ray := load('ray')

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

Metal := color => {
	color: color
	scatter: (r, rec, attenuation, scattered) => (
		reflected := (vec3.reflect)((vec3.norm)(r.dir), rec.normal)

		scattered.pos := rec.point
		scattered.dir := reflected

		attenuation.0 := color.0
		attenuation.1 := color.1
		attenuation.2 := color.2

		(vec3.dot)(scattered.dir, rec.normal) > 0
	)
}

Zero := Lambertian([0, 0, 0], 0.5)
