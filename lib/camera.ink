` camera abstraction `

util := load('util')
vec3 := load('vec3')
ray := load('ray')

vnorm := vec3.norm
vadd := vec3.add
vsub := vec3.sub
vmul := vec3.multiply
vdiv := vec3.divide
vcross := vec3.cross

create := (lookfrom, lookat, vup, fov, aspect) => (
	theta := (util.degreeToRadian)(fov)
	h := sin(theta / 2) / cos(theta / 2)

	viewportHeight := 2 * h
	viewportWidth := viewportHeight * aspect

	w := vnorm(vsub(lookfrom, lookat))
	u := vnorm(vcross(vup, w))
	v := vcross(w, u)

	origin := lookfrom
	horizontal := vmul(u, viewportWidth)
	vertical := vmul(v, viewportHeight)
	lowerLeft := vsub(
		origin
		vadd(
			vadd(
				vdiv(horizontal, 2), vdiv(vertical, 2)
			)
			w
		)
	)

	{
		origin: origin
		lowerLeft: lowerLeft
		horizontal: horizontal
		vertical: vertical
		getRay: (u, v) => (ray.create)(
			origin
			vsub(
				vadd(
					lowerLeft
					vadd(
						vmul(horizontal, u)
						vmul(vertical, v)
					)
				)
				origin
			)
		)
	}
)
