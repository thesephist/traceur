` utilities and shared constants `

Pi := 3.1415926535897932385

degreeToRadian := deg => deg * Pi / 180

randRange := (min, max) => min + rand() * (max - min)

clamp := (x, min, max) => x < min :: {
	true -> min
	false -> x > max :: {
		true -> max
		_ -> x
	}
}

doubleDigit := n => n > 9 :: {
	true -> string(n)
	false -> '0' + string(n)
}
