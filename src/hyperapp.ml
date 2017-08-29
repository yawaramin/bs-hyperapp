(*
type event
type data
type emit = event -> data -> data [@bs]
type ('s, 'a) app_props =
  < state : 's;
    view : ('s, 'a) view;
    actions : 'a Js.t Js.undefined;
    events :
      < loaded :
          ('s -> 'a Js.t -> unit -> emit [@bs]) array Js.undefined;

        action :
          ('s -> 'a Js.t -> data -> emit [@bs]) array Js.undefined;

        update :
          ('s -> 'a Js.t -> data -> emit [@bs]) array Js.undefined;

        render :
          ('s -> 'a Js.t -> ('s, 'a) view -> emit [@bs]) array > Js.t Js.undefined;

    plugins : (('s, 'a) app_props -> ('s, 'a) app_props [@bs]) Js.undefined;
    root : Web.Element.t Js.undefined > Js.t
*)

type vnode

type ('state, 'actions) view =
  'state Js.t -> 'actions Js.t -> vnode [@bs]

(**
@param root https://github.com/hyperapp/hyperapp/blob/f307aee3d14f0268660c277698c213d8e42cea8d/docs/root.md
*)
type ('state, 'actions) app_params =
  < state : 'state Js.t Js.undefined;
    view : ('state, 'actions) view;
    actions : 'actions Js.t Js.undefined;
    root : Bs_webapi.Dom.Element.t Js.undefined > Js.t

(**
https://github.com/hyperapp/hyperapp/blob/f307aee3d14f0268660c277698c213d8e42cea8d/docs/api.md#h

This binding takes an array of node children. See also `h_`.
*)
external h : string -> ?a:'attributes Js.t -> vnode array -> vnode =
  "" [@@bs.module "hyperapp"]

(** This binding takes a single text node. See also `h`. *)
external h_ : string -> ?a:'attributes Js.t -> string -> vnode =
  "h" [@@bs.module "hyperapp"]

external _app : ('state, 'actions) app_params -> unit =
  "app" [@@bs.module "hyperapp"]

(**
https://github.com/hyperapp/hyperapp/blob/f307aee3d14f0268660c277698c213d8e42cea8d/docs/api.md#app

Use OCaml-style named parameters instead of JavaScript-style param
object. Also put view function at end for a more DSL-like feel.
*)
let app ?state ?actions ?root view = _app [%bs.obj {
  state = Js.Undefined.from_opt state;
  view;
  actions = Js.Undefined.from_opt actions;
  root = Js.Undefined.from_opt root
}]

