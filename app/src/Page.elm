module Page exposing (..)

import Browser exposing (Document)
import Html exposing (Html, map)

view : { title : String, body : Html inMessage } -> (inMessage -> outMessage) -> Document outMessage
view { title, body } toMessage =
  { title = title
  , body = List.map (Html.map toMessage) [body]
  }
