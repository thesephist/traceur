#!/usr/bin/env ink

` traceur: a basic path tracer `

std := load('vendor/std')
bmp := load('vendor/bmp').bmp

log := std.log
f := std.format
range := std.range
map := std.map
reduce := std.reduce
writeFile := std.writeFile

vec3 := load('lib/vec3')
ray := load('lib/ray')
shape := load('lib/shape')
camera := load('lib/camera')

OutputPath := './out.bmp'

Width := 160
Height := 90
Aspect := Width / Height

SamplesPerPixel := 10
SamplesPerPixelRange := range(0, SamplesPerPixel, 1)

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

Camera := (camera.create)(
	Origin
	LowerLeft
	Horizontal
	Vertical
)

Shapes := (shape.collection)([
	(shape.sphere)(
		(vec3.create)(0, 0, ~1)
		0.5
	)
	(shape.sphere)(
		(vec3.create)(0, ~100.5, ~1)
		100
	)
])

` note that in ink/bmp, rgb is reversed `
color := r => (
	rec := (shape.hitRecord)(
		vec3.Zero
		vec3.Zero
		0
		false
	)

	(Shapes.hit)(r, 0, 9999999, rec) :: {
		true -> (
			[
				127 * (rec.normal.z + 1)
				127 * (rec.normal.y + 1)
				127 * (rec.normal.x + 1)
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

	sum := reduce(SamplesPerPixelRange, acc => (
		u := (x + rand()) / (Width - 1)
		v := (y + rand()) / (Height - 1)
		r := (Camera.getRay)(u, v)

		c := color(r)
		acc.0 := acc.0 + c.0
		acc.1 := acc.1 + c.1
		acc.2 := acc.2 + c.2
	), [0, 0, 0])

	[
		sum.0 / SamplesPerPixel
		sum.1 / SamplesPerPixel
		sum.2 / SamplesPerPixel
	]
))

file := bmp(Width, Height, data)

writeFile(OutputPath, file, r => r :: {
	() -> log('File write failed')
	_ -> log('File saved to ' + OutputPath)
})
