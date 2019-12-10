` library of basic shapes `

` shapes are designed to be "objects"
	with methods as closures that export objects
	with function references `

sphere := (pos, radius) => (
	geom := {
		pos: pos
		radius: radius
	}

	hit := ray => (
		` TODO `
	)
)

plane := (w, h) => (
	geom := {
		w: w ` ray representing width side `
		h: h ` ray representing height side `
	}

	hit := ray => (
		` TODO `
	)
)
