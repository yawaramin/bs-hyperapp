type 'msg vnode

external _h :
  string ->
  ?a:'attrs ->
  ([ `children of 'msg vnode array | `text of string ] [@bs.unwrap]) ->
  'msg vnode =
  "h" [@@bs.module "hyperapp"]

(**
https://github.com/hyperapp/hyperapp/blob/f307aee3d14f0268660c277698c213d8e42cea8d/docs/api.md#h

This binding takes a list of node children. See also `h_`.
*)
let h tagName ?a children =
  _h tagName ?a (`children (Array.of_list children))

(** This binding takes a single text node. See also `h`. *)
let h_ tagName ?a text = _h tagName ?a (`text text)

type 'model state = < model : 'model > Js.t

type ('model, 'msg) actions =
  < update :
    'model state ->
    ('model, 'msg) actions ->
    'msg ->
    'model state [@bs] > Js.t

type ('msg, 'a) viewActions = < update : 'msg -> 'a > Js.t

external _app :
  < state : 'model state;
    view : 'model state -> ('msg, 'a) viewActions -> 'msg vnode [@bs];
    actions : ('model, 'msg) actions;
    root : Bs_webapi.Dom.Element.t > Js.t -> unit =
  "app" [@@bs.module "hyperapp"]

(**
https://github.com/hyperapp/hyperapp/blob/f307aee3d14f0268660c277698c213d8e42cea8d/docs/api.md#app

Use OCaml-style named parameters instead of JavaScript-style param
object.
*)
let app ~model ~view ~update root =
  let view = fun [@bs] state actions ->
    view state##model (actions##update) in

  _app [%obj {
    state = [%obj { model }];
    view;

    actions =
      [%obj { update = fun [@bs] state _ payload ->
        [%obj { model = update state##model payload }] }];

    root =
      Js.Option.getExn
        Bs_webapi.Dom.(Document.getElementById root document) }]
