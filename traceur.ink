` main traceur program `

` vendored dependencies `
std := load('vendor/std')

log := std.log
f := std.format

` traceur dependencies / libraries `
trace := load('lib/trace')

` hello world -- take number from stdin and square it `
(std.scan)(s => (
	n := number(s)
	log(f('{{ n }} squared is {{ sq }}', {
		n: n,
		sq: n * n,
	}))
))
