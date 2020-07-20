` a ray is a vector out from a position in space `

vec3 := load('vec3')

vneg := vec3.neg
vadd := vec3.add
vsub := vec3.sub
vmul := vec3.multiply

create := (pos, dir) => {
	pos: pos
	dir: dir
}

Zero := create(vec3.Zero, vec3.Zero)

at := (ray, t) => vadd(ray.pos, vmul(ray.dir, t))

fromPoints := (from, to) => create(
	from
	vsub(to, from)
)

reverse := ray => create(
	ray.pos
	vneg(ray.dir)
)
