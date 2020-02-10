module Main exposing (..)

import Browser
import Html.Attributes exposing (placeholder, type_)
import Regex
import Html exposing (Html, br, div, input, text)
import Html.Events exposing (onInput)

main =
    Browser.sandbox { init = init, update = update, view = view }

type alias Model =
    { regex_string : String,
      text_string : String,
      regex_regex : Regex.Regex,
      matched_string : List String
    }

type Msg
    = ReadRegex String
    | ReadText String
    | MatchRegex String
              
init : Model
init =
    { regex_string = "", text_string = "", regex_regex = Regex.never, matched_string = [] }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ReadText content ->
            { model | text_string = content }
        ReadRegex str ->
            { model | regex_regex = Maybe.withDefault Regex.never <| Regex.fromString str }
        MatchRegex str ->
            { model | matched_string = Regex.split model.regex_regex <| str }



view : Model -> Html Msg
view model =
    div []
    [
        div []
        [ input [ type_ "text", placeholder "Your regex", onInput ReadRegex  ] [],
          br [] [],
          input [ type_ "text", placeholder "Your text", onInput ReadText  ] [],
          br [] [],
          text("String: " ++ model.text_string)
         ]
    ]

