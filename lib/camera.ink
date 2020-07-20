` camera abstraction `

vec3 := load('vec3')
ray := load('ray')

create := (origin, lowerLeft, horizontal, vertical) => {
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
