module Page.Book exposing ( Model
                          , Message
                          , init
                          , view
                          , update
                          , subscriptions
                          )

import Html exposing (..)
import Http



-- MODEL
type Model
  = Failure
  | Loading
  | Success String


init : (Model, Cmd Message)
init =
  ( Loading
  , Http.get
      { url = "https://elm-lang.org/assets/public-opinion.txt"
      , expect = Http.expectString GotText
      }
  )



-- UPDATE
type Message
  = GotText (Result Http.Error String)


update : Message -> Model -> (Model, Cmd Message)
update message _ =
  case message of
    GotText result ->
      case result of
        Ok fullText ->
          (Success fullText, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)



-- SUBSCRIPTIONS
subscriptions : Model -> Sub Message
subscriptions _ =
  Sub.none



-- VIEW
view : Model -> { title : String, body : Html Message }
view model =
  { title = "Game Tracker - Book"
  , body = div []
    [ case model of
        Failure ->
          text "I was unable to load your book."

        Loading ->
          text "Loading..."

        Success fullText ->
          pre [] [ text fullText ]
    ]
  }
