# bs-hyperapp

This library is an opinionated overlay of the [Elm
Architecture](https://guide.elm-lang.org/architecture/) on top of
[Hyperapp](https://hyperapp.js.org/), the tiny UI library. It's driven by the
realisation that because of strong static typing in languages like OCaml,
it's possible to simplify Hyperapp's actions into just a single update
function (a single reducer), and also to simplify a few other things.

## Usage

The main entry points are the `BsHyperapp.Hyperapp.{app,asyncApp}` functions,
which take an initial model, view, and update functions, and the (string)
HTML ID of a root element to mount the app on.

The model can be any valid OCaml type, and the update function takes a model
and a message (of any one type) and returns a new model (for `app`) or a
JavaScript promise of a new model (for `asyncApp`).

The view function takes a model and a 'message sender' function which is
hooked up to route update messages properly into Hyperapp, and returns a
rendering of the view which is composed of Hyperapp tags, which are created
with `BsHyperapp.Hyperapp.h` (for tags with children) and
`BsHyperapp.Hyperapp.h_` (for tags with a single text node as the body).

For an illustrative example, see `src/index.ml`.

### Difference between `app` and `asyncApp`

There are two different app runners (for now) because Elm does something
similar. The `app` runner is a simple synchronous runner like Elm's
http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html#beginnerProgram
, in that it doesn't manage effects like HTTP requests. The `asyncApp` runner
on the other hand does manage effects asynchronously, like Elm's
http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html#program . In
the future I may decide to unify the two using a parameterised OCaml module.

Unlike Elm's `program`, `asyncApp` has a (I believe) simpler way of managing
effects: its update function returns a JavaScript promise of a new model
instead of Elm's pair of (new model, effectful action to carry out).
