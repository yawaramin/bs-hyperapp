type 'msg vnode

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
