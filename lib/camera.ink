` camera abstraction `

util := load('util')
vec3 := load('vec3')
ray := load('ray')

vabs := vec3.abs
vnorm := vec3.norm
vadd := vec3.add
vsub := vec3.sub
vmul := vec3.multiply
vdiv := vec3.divide
vcross := vec3.cross
vrUD := vec3.randUnitDisk

rcr := ray.create

create := (lookfrom, lookat, vup, fov, aspect, aperture) => (
	focusDist := vabs(vsub(lookfrom, lookat))

	theta := (util.degreeToRadian)(fov)
	h := sin(theta / 2) / cos(theta / 2)

	viewportHeight := 2 * h
	viewportWidth := viewportHeight * aspect

	w := vnorm(vsub(lookfrom, lookat))
	u := vnorm(vcross(vup, w))
	v := vcross(w, u)

	origin := lookfrom
	horizontal := vmul(u, viewportWidth * focusDist)
	vertical := vmul(v, viewportHeight * focusDist)
	lowerLeft := vsub(
		origin
		vadd(
			vadd(
				vdiv(horizontal, 2), vdiv(vertical, 2)
			)
			vmul(w, focusDist)
		)
	)
	lensRadius := aperture / 2

	{
		getRay: (s, t) => (
			rd := vmul(vrUD(), lensRadius)
			originAndOffset := vadd(origin, vadd(vmul(u, rd.x), vmul(v, rd.y)))
			rcr(
				originAndOffset
				vsub(
					vadd(
						lowerLeft
						vadd(
							vmul(horizontal, s)
							vmul(vertical, t)
						)
					)
					originAndOffset
				)
			)
		)
	}
)
