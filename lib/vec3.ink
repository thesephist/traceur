` vec3 math library `

create := (x, y, z) => {x: x, y: y, z: z}

` square of length of a vec3 is often useful for comparisons,
	and faster when we don't actually need an abs() `
abssq := v => (v.x * v.x) + (v.y * v.y) + (v.z * v.z)
abs := v => pow(abssq(v), 0.5)
neg := v => {x: ~x, y: ~y, z: ~z}

` normalize vector against length of 1 `
norm := v => multiply(v, 1 / abs(v))

eq := (a, b) => (a.x = b.x) & (a.y = b.y) & (a.z = b.z)
add := (a, b) => {
	x: a.x + b.x
	y: a.y + b.y
	z: a.z + b.z
}
sub := (a, b) => add(a, neg(b))
multiply := (v, c) => {
	x: v.x / c
	y: v.y / c
	z: v.z / c
}
dot := (a, b) => a.x * b.x + a.y * b.y + a.z * b.z
cross := (a, b) => {
	x: a.y * b.z - a.z * b.y
	y: a.z * b.x - a.x * b.z
	z: a.x * b.y - a.y * b.x
}
