type 'msg vnode
type ('model, 'msg) view = 'model -> ('msg -> unit) -> 'msg vnode

external _h :
  string ->
  ?a:'attrs ->
  ([ `children of 'msg vnode array | `text of string ] [@bs.unwrap]) ->
  'msg vnode =
  "h" [@@bs.module "hyperapp"]

let h tagName ?a children =
  _h tagName ?a (`children (Array.of_list children))

let h_ tagName ?a text = _h tagName ?a (`text text)

external targetOfEvent : 'event -> Bs_webapi.Dom.Element.t =
  "target" [@@bs.get]

external valueOfTarget : Bs_webapi.Dom.Element.t -> string =
  "value" [@@bs.get]

let valueOfEvent e = e |> targetOfEvent |> valueOfTarget

type 'model state = < model : 'model > Js.t

type ('model, 'msg) actions =
  < update :
    'model state ->
    (*
    We don't really need to model this parameter exactly, since we only
    have one action function (`update`) and it's not going to call
    itself in our design, but it's easier to keep it than introduce a
    new type.
    *)
    ('model, 'msg) actions ->
    'msg ->
    'model state [@bs] > Js.t

type ('model, 'msg) _view =
  'model state -> < update : 'msg -> unit > Js.t -> 'msg vnode [@bs]

external _app :
  < state : 'model state;
    view : ('model, 'msg) _view;
    actions : ('model, 'msg) actions;
    root : Bs_webapi.Dom.Element.t > Js.t -> unit =
  "app" [@@bs.module "hyperapp"]

type ('model, 'msg) asyncActions =
  < update :
    'model state ->
    ('model, 'msg) asyncActions ->
    'msg ->
    (('model state -> unit Js.Promise.t) -> unit Js.Promise.t [@bs]) [@bs] > Js.t

external _asyncApp :
  < state : 'model state;
    view : ('model, 'msg) _view;
    actions : ('model, 'msg) asyncActions;
    root : Bs_webapi.Dom.Element.t > Js.t -> unit =
  "app" [@@bs.module "hyperapp"]

let viewOf view = fun [@bs] state actions ->
  view state##model actions##update

let rootOf root =
  Js.Option.getExn Bs_webapi.Dom.(Document.getElementById root document)

let app ~model ~view ~update root =
  _app [%obj {
    state = [%obj { model }];
    view = viewOf view;

    actions =
      [%obj { update = fun [@bs] state _ payload ->
        [%obj { model = update state##model payload }] }];

    root = rootOf root }]

let asyncApp ~model ~view ~update root =
  _asyncApp [%obj {
    state = [%obj { model }];
    view = viewOf view;
    actions =
      [%obj { update = fun [@bs] state _ payload -> fun [@bs] update' ->
        payload |> update state##model |> Js.Promise.then_ (fun model' ->
          update' [%obj { model = model' }]) }];

    root = rootOf root }]
