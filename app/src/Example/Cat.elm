module Example.Cat exposing (..)

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
type alias Model
  = { status : Status
    }


init : (Model, Cmd Msg)
init =
  ( Model Loading
  , getRandomCatGif
  )



-- UPDATE
type Msg
  = MorePlease
  | GotGif (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      ({ model | status = Loading}, getRandomCatGif)

    GotGif result ->
      case result of
        Ok url ->
          ({ model | status = Success url}, Cmd.none)

        Err _ ->
          ({ model | status = Failure}, Cmd.none)



-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none



-- VIEW
view : Model -> Html msg
view model =
  div []
    [ h2 [] [ text "Random Cats" ]
    , viewGif model
    ]


viewGif : Model -> Html msg
viewGif model =
  div [] []
  case model.status of
    Failure ->
      div []
        [ text "I could not load a random cat for some reason. "
        , button [ onClick MorePlease ] [ text "Try Again!" ]
        ]
    _ -> div [] []

  --   Loading ->
  --     div []
  --       [ text "Loading..."]

  --   Success url ->
  --     div []
  --       [ button [ onClick MorePlease, style "display" "block" ] [ text "More Please!" ]
  --       , img [ src url ] []
  --       ]



-- HTTP
getRandomCatGif : Cmd Msg
getRandomCatGif =
  Http.get
    { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
    , expect = Http.expectJson GotGif gifDecoder
    }


gifDecoder : Decoder String
gifDecoder =
  field "data" (field "image_url" string)
