` camera abstraction `

util := load('util')
vec3 := load('vec3')
ray := load('ray')

create := (fov, aspect) => (
	theta := (util.degreeToRadian)(fov)
	h := sin(theta / 2) / cos(theta / 2)

	viewportHeight := 2 * h
	viewportWidth := viewportHeight * aspect
	focalLength := 1

	origin := (vec3.create)(0, 0, 0)
	horizontal := (vec3.create)(viewportWidth, 0, 0)
	vertical := (vec3.create)(0, viewportHeight, 0)
	lowerLeft := (vec3.sub)(
		origin
		(vec3.add)(
			(vec3.add)(
				(vec3.divide)(horizontal, 2), (vec3.divide)(vertical, 2)
			)
			(vec3.create)(0, 0, focalLength)
		)
	)

	{
		origin: origin
		lowerLeft: lowerLeft
		horizontal: horizontal
		vertical: vertical
		getRay: (u, v) => (ray.create)(
			origin
			(vec3.sub)(
				(vec3.add)(
					lowerLeft
					(vec3.add)(
						(vec3.multiply)(horizontal, u)
						(vec3.multiply)(vertical, v)
					)
				)
				origin
			)
		)
	}
)
