` a ray is a vector out from a position in space `

vec3 := load('vec3')

veq := vec3.eq

create := (pos, dir) => {
	pos: pos
	dir: dir
}

eq := (a, b) => veq(a.pos, b.pos) & veq(a.dir, b.dir)

at := (ray, t) => (vec3.add)(ray.pos, (vec.multiply)(ray.dir, t))

fromPoints := (from, to) => create(
	from
	(vec3.sub)(to, from)
)

reverse := ray => create(
	ray.pos
	(vec3.neg)(ray.dir)
)

` note that in ink/bmp, rgb is reversed `
color := ray => (
	unitDir := (vec3.norm)(ray.dir)
	t := 0.5 * (unitDir.y + 1)
	(vec3.list)(
		(vec3.multiply)(
			(vec3.add)(
				(vec3.multiply)((vec3.create)(1, 1, 1), 1 - t)
				(vec3.create)(t, 0.7 * t, 0.5 * t)
			)
			255
		)
	)
)
