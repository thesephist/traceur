` library of basic shapes and hit testing algorithms `

std := load('../vendor/std')

reduce := std.reduce

vec3 := load('vec3')
ray := load('ray')
material := load('material')

vneg := vec3.neg
vsub := vec3.sub
vdiv := vec3.divide
vabssq := vec3.abssq
vdot := vec3.dot

` hit record encapsulates data that hit and scattering algorithms
	use to recursively march a ray `
hitRecord := (point, normal, material, t, frontFace) => self := {
	point: point
	normal: normal
	material: material
	t: t
	frontFace: frontFace
	setFaceNormal: (r, outwardNormal) => (
		self.frontFace := vdot(r.dir, outwardNormal) < 0
		self.normal := (self.frontFace :: {
			true -> outwardNormal
			false -> vneg(outwardNormal)
		})
	)
}

hitRecordZero := hitRecord(
	vec3.Zero
	vec3.Zero
	material.Zero
	0
	false
)

` hittable shapes

	shapes are designed to be "objects"
	with methods as closures that export objects
	with function references `

sphere := (pos, radius, material) => {
	pos: pos
	radius: radius
	material: material
	hit: (r, tMin, tMax, rec) => (
		oc := vsub(r.pos, pos)
		a := vabssq(r.dir)
		halfB := vdot(oc, r.dir)
		c := vabssq(oc) - radius * radius
		discriminant := halfB * halfB - a * c
		discriminant < 0 :: {
			true -> false
			false -> (
				root := pow(discriminant, 0.5)
				t1 := (~halfB + root) / a
				t2 := (~halfB - root) / a

				inRange := t => t < tMax & t > tMin
				inRange(t2) :: {
					true -> (
						rec.t := t2
						rec.point := (ray.at)(r, t2)
						outwardNormal := vdiv(vsub(rec.point, pos), radius)
						(rec.setFaceNormal)(r, outwardNormal)
						rec.material := material
						true
					)
					false -> inRange(t1) :: {
						true -> (
							rec.t := t1
							rec.point := (ray.at)(r, t1)
							outwardNormal := vdiv(vsub(rec.point, pos), radius)
							(rec.setFaceNormal)(r, outwardNormal)
							rec.material := material
							true
						)
						false -> false
					}
				}
			)
		}
	)
}

collection := items => {
	items: items
	hit: (r, tMin, tMax, rec) => (
		tmp := {
			rec: hitRecordZero
			hitAnything: false
			closestSoFar: tMax
		}
		r := reduce(items, (tmp, item) => (
			(item.hit)(r, tMin, tmp.closestSoFar, tmp.rec) :: {
				true -> (
					tmp.closestSoFar := tmp.rec.t
					tmp.hitAnything := true
				)
				false -> tmp
			}
		), tmp)

		rec.point := r.rec.point
		rec.normal := r.rec.normal
		rec.material := r.rec.material
		rec.t := r.rec.t
		rec.frontFace := r.rec.frontFace

		r.hitAnything
	)
}
