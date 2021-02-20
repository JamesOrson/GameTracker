module Page.Clock exposing ( Model
                          , Message
                          , init
                          , view
                          , update
                          , subscriptions
                          )

import Html exposing (..)
import Task
import Time



-- MODEL
type alias Model =
  { zone : Time.Zone
  , time : Time.Posix
  }


init : (Model, Cmd Message)
init =
  ( Model Time.utc (Time.millisToPosix 0)
  , Task.perform AdjustTimeZone Time.here
  )



-- UPDATE
type Message
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone



update : Message -> Model -> (Model, Cmd Message)
update message model =
  case message of
    Tick newTime ->
      ( { model | time = newTime }
      , Cmd.none
      )

    AdjustTimeZone newZone ->
      ( { model | zone = newZone }
      , Cmd.none
      )



-- SUBSCRIPTIONS
subscriptions : Model -> Sub Message
subscriptions _ =
  Time.every 1000 Tick



-- VIEW
view : Model -> { title : String, body : Html Message }
view model =
  let
    hour   = String.fromInt (Time.toHour   model.zone model.time)
    minute = String.fromInt (Time.toMinute model.zone model.time)
    second = String.fromInt (Time.toSecond model.zone model.time)
  in
  { title = "Game Tracker - Clock"
  , body = h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
  }
