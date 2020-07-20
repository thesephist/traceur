#!/usr/bin/env ink

` traceur: a basic path tracer `

std := load('vendor/std')
bmp := load('vendor/bmp').bmp

log := std.log
f := std.format
range := std.range
map := std.map
writeFile := std.writeFile

OutputPath := './out.bmp'

Width := 120
Height := 120

data := map(range(0, Width * Height, 1), i => (
	x := i % Width
	y := floor(i / Height)

	[
		255 * x / (Width - 1)
		255 * y / (Height - 1)
		64
	]
))

file := bmp(Width, Height, data)

writeFile(OutputPath, file, r => r :: {
	() -> log('File write failed')
	_ -> log('File saved to ' + OutputPath)
})
