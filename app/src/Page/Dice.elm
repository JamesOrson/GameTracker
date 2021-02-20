module Page.Dice exposing ( Model
                          , Message
                          , init
                          , view
                          , update
                          , subscriptions
                          )

import Html exposing (..)
import Html.Events exposing (..)
import Random



-- MODEL
type alias Model = Int


init : (Model, Cmd Message)
init =
  ( 0
  , rollDice
  )



-- UPDATE
type Message
  = Roll
  | NewFace Int


update : Message -> Model -> (Model, Cmd Message)
update message model =
  case message of
    Roll ->
      ( model
      , rollDice
      )

    NewFace newFace ->
      ( newFace
      , Cmd.none
      )



-- SUBSCRIPTIONS
subscriptions : Model -> Sub Message
subscriptions _ =
  Sub.none



-- VIEW
view : Model -> { title : String, body : Html Message }
view model =
  { title = "Game Tracker - Dice"
  , body = div []
    [ h1 [] [ text (String.fromInt model) ]
    , button [ onClick Roll ] [ text "Roll" ]
    ]
  }

-- RANDOM
rollDice : Cmd Message
rollDice =
  Random.generate NewFace (Random.int 1 6)