` a ray is a vector out from a position in space `

vec3 := load('vec3')

veq := vec3.eq

create := (pos, dir) => {
	pos: pos
	dir: dir
}

eq := (a, b) => veq(a.pos, b.pos) & veq(a.dir, b.dir)

fromPoints := (from, to) => {
	create(
		pos: from
		dir: (vec3.sub)(to, from)
	)
}

reverse := ray => create(
	ray.pos
	(vec3.neg)(ray.dir)
)