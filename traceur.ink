#!/usr/bin/env ink

` traceur: a basic path tracer `

std := load('vendor/std')
bmp := load('vendor/bmp').bmp

log := std.log
f := std.format
range := std.range
map := std.map
writeFile := std.writeFile

vec3 := load('lib/vec3')
ray := load('lib/ray')
shape := load('lib/shape')

OutputPath := './out.bmp'

Width := 160
Height := 90
Aspect := Width / Height

ViewportHeight := 2
ViewportWidth := ViewportHeight * Aspect
FocalLength := 1

Origin := (vec3.create)(0, 0, 0)
Horizontal := (vec3.create)(ViewportWidth, 0, 0)
Vertical := (vec3.create)(0, ViewportHeight, 0)
Focus := (vec3.create)(0, 0, FocalLength)
LowerLeft := (vec3.sub)(
	Origin
	(vec3.add)(
		(vec3.add)(
			(vec3.divide)(Horizontal, 2), (vec3.divide)(Vertical, 2)
		)
		Focus
	)
)

` scene setup:
	- viewport 2 units tall
	- focal length: 1 unit
	- right-handed coordinates, camera looking -z direction `

` scene descriptions `

Sphere := (shape.sphere)(
	(vec3.create)(0, 0, ~1)
	0.5
)

` note that in ink/bmp, rgb is reversed `
color := r => (
	t := (Sphere.hit)(r)
	t > 0 :: {
		true -> (
			normal := (vec3.norm)((vec3.sub)((ray.at)(r, t), Sphere.pos))
			[
				127 * (normal.z + 1)
				127 * (normal.y + 1)
				127 * (normal.x + 1)
			]
		)
		false -> (
			unitDir := (vec3.norm)(r.dir)
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
	}
)

progress := {
	time: time()
}

data := map(range(0, Width * Height, 1), i => (
	x := i % Width
	y := floor(i / Width)

	` progress indicator for every row `
	x :: {
		0 -> (
			t := time()
			elapsed := t - progress.time
			progress.time := t
			log(f('Rendering row {{0}} -> {{1}}px/sec', [y, floor(Width / elapsed)]))
		)
	}

	u := x / (Width - 1)
	v := y / (Height - 1)
	uu := (vec3.multiply)(Horizontal, u)
	vv := (vec3.multiply)(Vertical, v)

	r := (ray.create)(
		Origin
		(vec3.sub)(
			(vec3.add)(
				LowerLeft
				(vec3.add)(uu, vv)
			)
			Origin
		)
	)

	color(r)
))

file := bmp(Width, Height, data)

writeFile(OutputPath, file, r => r :: {
	() -> log('File write failed')
	_ -> log('File saved to ' + OutputPath)
})
