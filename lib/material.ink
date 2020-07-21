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

` Matte material approximates a true Lambertian surface
	by randomly picking a reflection direction from
	points uniformly distributed inside a unit sphere
	tangent to the hit point. `
Matte := (color) => {
	color: color
	scatter: (r, rec, attenuation, scattered) => (
		scattered.pos := rec.point
		scattered.dir := vadd(rec.normal, vrUS())

		attenuation.0 := color.0
		attenuation.1 := color.1
		attenuation.2 := color.2
		true
	)
}

` Lambertian material is a diffusive surface
	that biases towards reflecting toward the surface normal `
Lambertian := (color) => {
	color: color
	scatter: (r, rec, attenuation, scattered) => (
		scattered.pos := rec.point
		scattered.dir := vadd(rec.normal, vrUV())

		attenuation.0 := color.0
		attenuation.1 := color.1
		attenuation.2 := color.2
		true
	)
}

` Metal material reflects rays such that the incidence
	and reflection angles are the same, within a small fuzz margin `
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

` Mirror material is a perfectly reflective Metal `
Mirror := color => Metal(color, 0)

` Schlick formula for total internal reflection
	used in Dielectric material `
schlick := (cosine, ri) => (
	r0 := (1 - ri) / (1 + ri)
	r0 := r0 * r0
	r0 + (1 - r0) * pow(1 - cosine, 5)
)

` Dielectric material represents a refractive
	material like water or glass following Snell's rule.
	ri is the refractive index `
Dielectric := ri => {
	ri: ri
	scatter: (r, rec, attenuation, scattered) => (
		attenuation.0 = 1
		attenuation.1 = 1
		attenuation.2 = 1
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

` Glass is a dielectric material with ri approximating real glass `
Glass := Dielectric(1.517)

` Water is a dielectric material with ri approximating real water `
Water := Dielectric(1.333)

` Diamond is a dielectric material with ri approximating real diamond `
Diamond := Dielectric(2.417)

` Zero material is a grey Lambertian material and the
	default material for shapes `
Zero := Lambertian([0.5, 0.5, 0.5], 0.5)
