module Example.Dice exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Random



-- MODEL
type alias Model = Int


init : () -> (Model, Cmd Msg)
init _ =
  ( 0
  , rollDice
  )



-- UPDATE
type Msg
  = Roll
  | NewFace Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      ( model
      , rollDice
      )

    NewFace newFace ->
      ( newFace
      , Cmd.none
      )



-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none



-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text (String.fromInt model) ]
    , button [ onClick Roll ] [ text "Roll" ]
    ]

-- RANDOM
rollDice : Cmd Msg
rollDice =
  Random.generate NewFace (Random.int 1 6)