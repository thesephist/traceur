# traceur

Traceur is an experimental pathtracing 3D renderer written in [Ink](https://github.com/thesephist/ink), a dynamically-typed, functional programming language I made in the summer of 2019.

## Motivation

## Design

## Resources and further reading

- Ray Tracing in One Weekend: [https://raytracing.github.io/](https://raytracing.github.io/)
- Kevin Beason's mini pathtracer projects:
    - smallpt: [https://www.kevinbeason.com/smallpt/](https://www.kevinbeason.com/smallpt/)
    - livecoding stream: [https://www.youtube.com/watch?v=PGuxfdyaKJU](https://www.youtube.com/watch?v=PGuxfdyaKJU)
- _The Ray Tracer Challenge_: [https://www.amazon.com/Ray-Tracer-Challenge-Test-Driven-Renderer/dp/1680502719](https://www.amazon.com/Ray-Tracer-Challenge-Test-Driven-Renderer/dp/1680502719)
- Haskell Ray Tracer: [https://wiki.haskell.org/The_Monad.Reader/Issue5/HRay:_A_Haskell_ray_tracer](https://wiki.haskell.org/The_Monad.Reader/Issue5/HRay:_A_Haskell_ray_tracer)

## Usage

Make sure you have Ink installed on your system.

- `make` (or `make run`) to run the pathtracer. The output file defaults to `./out.bmp`
- `make check` to run all unit tests
- `make fmt` to autoformat all files with [inkfmt](https://github.com/thesephist/inkfmt), if you have it installed
