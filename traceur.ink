` main traceur program `

` vendored dependencies `
std := load('vendor/std')

log := std.log
f := std.format
range := std.range
each := std.each

` traceur dependencies / libraries `
vec3 := load('lib/vec3')
ray := load('lib/ray')
shape := load('lib/shape')
trace := load('lib/trace')

Vec3 := vec3.create
Ray := ray.create

` actually render a scene `

window := {
	width: 640
	height: 480
}

camera := Ray(
	Vec3(0, 0, 0)
	Vec3(0, 0, ~1)
)
sph1 := (shape.sphere)(
	Vec3(0, 0, 30)
	15
)

` cast rays from camera `
` NOTE: loops like this can be more efficient, but
    not the focus here atm `
each(range(0, window.width, 1), w => (
	each(range(0, window.height, 1), h => (
		` TODO `
	))
))
