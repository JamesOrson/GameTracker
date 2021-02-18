module Routes exposing (Route(..), fromUrl, toRouteString, toString)

import Browser.Navigation as Nav
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)



type Route
  = Home
  | Cat
  | NotFound

routeParser : Parser (Route -> a) a
routeParser =
  oneOf
    [ Parser.map Home Parser.top
    , Parser.map Cat (s "cat")
    ]

fromUrl : Url -> Route
fromUrl url =
  case (Parser.parse routeParser url) of
    Just route ->
      route
    Nothing ->
      NotFound

toRouteString : Route -> String
toRouteString route =
  "/" ++ String.join "/" (routeParts route)

toString : Route -> String
toString route =
  case route of
    Home ->
      "home"
    
    Cat ->
      "cat"
    
    NotFound ->
      "404"

routeParts : Route -> List String
routeParts route =
  case route of
    Home ->
      []

    Cat ->
      ["cat"]
    
    NotFound ->
      []