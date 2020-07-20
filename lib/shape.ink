` library of basic shapes `

std := load('../vendor/std')

each := std.each

vec3 := load('vec3')
ray := load('ray')
material := load('material')

` hit record `
hitRecord := (point, normal, material, t, frontFace) => self := {
	point: point
	normal: normal
	material: material
	t: t
	frontFace: frontFace
	setFaceNormal: (r, outwardNormal) => (
		self.frontFace := (vec3.dot)(r.dir, outwardNormal) < 0
		self.normal := (self.frontFace :: {
			true -> outwardNormal
			false -> (vec3.neg)(outwardNormal)
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
		oc := (vec3.sub)(r.pos, pos)
		a := (vec3.abssq)(r.dir)
		halfB := (vec3.dot)(oc, r.dir)
		c := (vec3.abssq)(oc) - radius * radius
		discriminant := halfB * halfB - a * c
		discriminant < 0 :: {
			true -> false
			false -> (
				root := pow(discriminant, 0.5)
				t1 := (~halfB + root) / a
				t2 := (~halfB - root) / a

				inRange := t => t < tMax & t > tMin
				[inRange(t1), inRange(t2)] :: {
					[_, true] -> (
						rec.t := t2
						rec.point := (ray.at)(r, t2)
						outwardNormal := (vec3.divide)((vec3.sub)(rec.point, pos), radius)
						(rec.setFaceNormal)(r, outwardNormal)
						rec.material := material
						true
					)
					[true, _] -> (
						rec.t := t1
						rec.point := (ray.at)(r, t1)
						outwardNormal := (vec3.divide)((vec3.sub)(rec.point, pos), radius)
						(rec.setFaceNormal)(r, outwardNormal)
						rec.material := material
						true
					)
					_ -> false
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

		each(items, item => (
			(item.hit)(r, tMin, tmp.closestSoFar, tmp.rec) :: {
				true -> (
					tmp.hitAnything := true
					tmp.closestSoFar := tmp.rec.t

					rec.point := tmp.rec.point
					rec.normal := tmp.rec.normal
					rec.material := tmp.rec.material
					rec.t := tmp.rec.t
					rec.frontFace := tmp.rec.frontFace
				)
			}
		))

		tmp.hitAnything
	)
}
