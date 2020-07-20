` a ray is a vector out from a position in space `

vec3 := load('vec3')

veq := vec3.eq

create := (pos, dir) => {
	pos: pos
	dir: dir
}

Zero := create(vec3.Zero, vec3.Zero)

eq := (a, b) => veq(a.pos, b.pos) & veq(a.dir, b.dir)

at := (ray, t) => (vec3.add)(ray.pos, (vec3.multiply)(ray.dir, t))

fromPoints := (from, to) => create(
	from
	(vec3.sub)(to, from)
)

reverse := ray => create(
	ray.pos
	(vec3.neg)(ray.dir)
)
