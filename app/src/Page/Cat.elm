module Page.Cat exposing ( Model
                          , Message
                          , init
                          , view
                          , update
                          , subscriptions
                          )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)



type Status
  = Failure
  | Loading
  | Success String



-- MODEL
type alias Model = Status


init : (Model, Cmd Message)
init =
  ( Loading
  , getRandomCatGif
  )



-- UPDATE
type Message
  = MorePlease
  | GotGif (Result Http.Error String)


update : Message -> Model -> (Model, Cmd Message)
update message model =
  case message of
    MorePlease ->
      (Loading, getRandomCatGif)

    GotGif result ->
      case result of
        Ok url ->
          (Success url, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)



-- SUBSCRIPTIONS
subscriptions : Model -> Sub Message
subscriptions _ =
  Sub.none



-- VIEW
view : Model -> { title : String, body : Html Message }
view model =
  { title = "Game Tracker - Cat"
  , body = div []
    [ h2 [] [ text "Random Cats" ]
    , viewGif model
    ]
  }


viewGif : Model -> Html Message
viewGif model =
  case model of
    Failure ->
      div []
        [ text "I could not load a random cat for some reason. "
        , button [ onClick MorePlease ] [ text "Try Again!" ]
        ]

    Loading ->
      div []
        [ text "Loading..."]

    Success url ->
      div []
        [ button [ onClick MorePlease, style "display" "block" ] [ text "More Please!" ]
        , img [ src url ] []
        ]



-- HTTP
getRandomCatGif : Cmd Message
getRandomCatGif =
  Http.get
    { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
    , expect = Http.expectJson GotGif gifDecoder
    }


gifDecoder : Decoder String
gifDecoder =
  field "data" (field "image_url" string)
