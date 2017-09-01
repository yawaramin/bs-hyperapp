(**
https://github.com/hyperapp/hyperapp/blob/f307aee3d14f0268660c277698c213d8e42cea8d/docs/api.md#vnode
*)
type 'msg vnode

(**
https://github.com/hyperapp/hyperapp/blob/f307aee3d14f0268660c277698c213d8e42cea8d/docs/api.md#h

Takes a list of node children. See also `h_`.
*)
val h : string -> ?a:'attrs -> 'msg vnode list -> 'msg vnode

(** Takes a single text node. See also `h`. *)
val h_ : string -> ?a:'attrs -> string -> 'msg vnode
val valueOfEvent : 'event -> string

(**
https://github.com/hyperapp/hyperapp/blob/f307aee3d14f0268660c277698c213d8e42cea8d/docs/api.md#app

Use OCaml-style named parameters instead of JavaScript-style param
object.
*)
val app :
  model:'model ->
  view:('model ->
  ('msg -> unit) -> 'msg vnode) ->
  update:('model -> 'msg -> 'model) ->
  string ->
  unit
