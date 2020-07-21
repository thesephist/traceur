#!/usr/bin/env ink

` traceur: a path tracer `

std := load('vendor/std')
bmp := load('vendor/bmp').bmp

log := std.log
f := std.format
range := std.range
map := std.map
reduce := std.reduce
writeFile := std.writeFile

util := load('lib/util')
vec3 := load('lib/vec3')
ray := load('lib/ray')
shape := load('lib/shape')
camera := load('lib/camera')
material := load('lib/material')

doubleDigit := util.doubleDigit
v := vec3.create
vnorm := vec3.norm
vadd := vec3.add
vmul := vec3.multiply
vlist := vec3.list
sphere := shape.sphere

OutputPath := './out.bmp'

Width := 720
Height := 480
MaxDepth := 50
SamplesPerPixel := 16
SamplesPerPixelRangeX := map(range(0, SamplesPerPixel, 1), rand)

` scene setup `

Camera := (camera.create)(
	v(~7, 2, 2)
	v(0, 0, ~1.8)
	v(0, 1, 0)
	15
	Width / Height
	0.16
)

` started 5:24 `

Shapes := (shape.collection)([
	` backdrop `
	sphere(v(0, ~100.5, ~1), 100, (material.Metal)([0.65, 0.75, 0.75], 0.2))
	sphere(v(0, 0, ~101.8), 100, (material.Mirror)([0.99, 0.99, 0.99]))
	` objects `
	sphere(v(~1, 0, ~1), 0.5, material.Glass)
	sphere(v(~1, 0, ~1), ~0.36, material.Glass)
	sphere(v(0, ~0.14, ~1), 0.36, (material.Lambertian)([0.65, 0.714, 0.067]))
	sphere(v(1, 0.14, ~1), 0.64, (material.Metal)([0.5, 0.6, 0.9], 0.12))
])

Black := [0, 0, 0]

` main function to recursively raymarch until we determine a color
	for the ray or reach max recursion depth.
	note that in ink/bmp, rgb is reversed (bgr) `
color := (r, depth) => depth :: {
	0 -> Black
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
			false -> Black
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
	pxWritten: 0
	startTime: time()
}

` render the scene by pathtracing from each pixel iteratively `
data := map(range(0, Width * Height, 1), i => (
	x := i % Width
	y := floor(i / Width)

	` progress indicator for every row `
	x :: {
		0 -> (
			progress.pxWritten := progress.pxWritten + Width
			elapsed := time() - progress.startTime
			remainingPx := Width * Height - i
			speed := progress.pxWritten / elapsed
			remainingSecs := remainingPx / speed
			log(f(
				'Rendering row {{0}} -> {{1}}px/sec. {{2}}:{{3}} remaining.'
				[
					y
					floor(speed)
					floor(remainingSecs / 60)
					doubleDigit(floor(remainingSecs % 60))
				]
			))
		)
	}

	getRay := Camera.getRay
	sum := reduce(SamplesPerPixelRangeX, (acc, xr) => (
		c := color(
			getRay(
				(x + xr) / (Width - 1)
				` direct rand() call here is faster than fetching
					a globally cached random value from a list `
				(y + rand()) / (Height - 1)
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

` create the binary bitmap file `
file := bmp(Width, Height, data)

` save / write the file to disk `
writeFile(OutputPath, file, r => r :: {
	() -> log('File write failed')
	_ -> log('File saved to ' + OutputPath)
})
