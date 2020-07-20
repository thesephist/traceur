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
material := load('lib/material')

v := vec3.create
vnorm := vec3.norm
vadd := vec3.add
vmul := vec3.multiply
vlist := vec3.list
sphere := shape.sphere

OutputPath := './out.bmp'

Width := 320
Height := 180

MaxDepth := 50
SamplesPerPixel := 30
SamplesPerPixelRangeX := map(range(0, SamplesPerPixel, 1), rand)
SamplesPerPixelRangeY := map(range(0, SamplesPerPixel, 1), rand)

` scene setup `

Camera := (camera.create)(
	v(~3, 3, 2)
	v(0, 0, ~1)
	v(0, 1, 0)
	30
	Width / Height
	0.75
)

Shapes := (shape.collection)([
	sphere(
		v(0, 0, ~1)
		0.5
		(material.Lambertian)([0.6, 0.5, 0.3])
	)
	sphere(
		v(0, ~100.5, ~1)
		100
		(material.Lambertian)([0.5, 0.5, 0.5])
	)
	sphere(
		v(~1, 0, ~1)
		0.5
		material.Glass
	)
	sphere(
		v(~1, 0, ~1)
		~0.4
		material.Glass
	)
	sphere(
		v(1, 0, ~1)
		0.5
		(material.Metal)([0.2, 0.6, 0.8], 0.12)
	)
])

Zero := [0, 0, 0]

` note that in ink/bmp, rgb is reversed `
color := (r, depth) => depth :: {
	0 -> Zero
	_ -> (Shapes.hit)(r, 0.0001, 9999999, rec := shape.hitRecordZero) :: {
		true -> (rec.material.scatter)(r, rec, attenuation := [1, 1, 1], scattered := ray.Zero) :: {
			true -> (
				c := color(scattered, depth - 1)
				[
					attenuation.0 * c.0
					attenuation.1 * c.1
					attenuation.2 * c.2
				]
			)
			false -> Zero
		}
		false -> (
			t := 0.5 * (vnorm(r.dir).y + 1)
			vlist(
				vadd(
					vmul(v(1, 1, 1), 1 - t)
					v(t, 0.7 * t, 0.5 * t)
				)
			)
		)
	}
}

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

	getRay := Camera.getRay
	sum := reduce(SamplesPerPixelRangeX, (acc, xr, i) => (
		c := color(
			getRay(
				(x + xr) / (Width - 1)
				(y + SamplesPerPixelRangeY.(i)) / (Height - 1)
			)
			MaxDepth
		)
		acc.0 := acc.0 + c.0
		acc.1 := acc.1 + c.1
		acc.2 := acc.2 + c.2
	), [0, 0, 0])

	[
		pow(sum.0 / SamplesPerPixel, 0.5) * 255
		pow(sum.1 / SamplesPerPixel, 0.5) * 255
		pow(sum.2 / SamplesPerPixel, 0.5) * 255
	]
))

file := bmp(Width, Height, data)

writeFile(OutputPath, file, r => r :: {
	() -> log('File write failed')
	_ -> log('File saved to ' + OutputPath)
})
