` material abstraction `

vec3 := load('vec3')
ray := load('ray')

vnorm := vec3.norm
vneg := vec3.neg
vadd := vec3.add
vmul := vec3.multiply
vdot := vec3.dot
vrefl := vec3.reflect
vrefr := vec3.refract
vrUS := vec3.randUnitSphere
vrUV := vec3.randUnitVec

Matte := (color) => {
	color: color
	scatter: (r, rec, attenuation, scattered) => (
		scatterDir := vadd(rec.normal, vrUS())

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
		scatterDir := vadd(rec.normal, vrUV())

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
		reflected := vrefl(vnorm(r.dir), rec.normal)

		scattered.pos := rec.point
		scattered.dir := (fuzz :: {
			0 -> reflected
			_ -> vadd(reflected, vmul(vrUV(), fuzz))
		})

		attenuation.0 := color.0
		attenuation.1 := color.1
		attenuation.2 := color.2

		vdot(scattered.dir, rec.normal) > 0
	)
}

` perfectly reflective Metal `
Mirror := color => Metal(color, 0)

schlick := (cosine, ri) => (
	r0 := (1 - ri) / (1 + ri)
	r0 := r0 * r0
	r0 + (1 - r0) * pow((1 - cosine), 5)
)

` ri: refractive index `
Dielectric := ri => {
	ri: ri
	scatter: (r, rec, attenuation, scattered) => (
		attenuation := [1, 1, 1]
		eta := (rec.frontFace :: {
			true -> 1 / ri
			false -> ri
		})

		unitDir := vnorm(r.dir)
		cosThetaTmp := vdot(vneg(unitDir), rec.normal)
		cosTheta := (cosThetaTmp > 1 :: {
			true -> 1
			false -> cosThetaTmp
		})
		sinTheta := pow(1 - cosTheta * cosTheta, 0.5)
		eta * sinTheta > 1 :: {
			true -> (
				reflected := vrefl(unitDir, rec.normal)

				scattered.pos := rec.point
				scattered.dir := reflected

				true
			)
			false -> schlick(cosTheta, eta) > rand() :: {
				true -> (
					reflected := vrefl(unitDir, rec.normal)

					scattered.pos := rec.point
					scattered.dir := reflected

					true
				)
				false -> (
					refracted := vrefr(unitDir, rec.normal, eta)

					scattered.pos := rec.point
					scattered.dir := refracted

					true
				)
			}
		}
	)
}

Glass := Dielectric(1.517)

Water := Dielectric(1.333)

Diamond := Dielectric(2.417)

Zero := Lambertian([0, 0, 0], 0.5)
