module Mwc.Chips exposing (extraAttributes, label, removeClick, view)

{-| Material design Chips

@docs extraAttributes, label, removeClick, view

-}

import Html.Styled exposing (Attribute, Html, div, i, text)
import Html.Styled.Attributes as Attr
import Html.Styled.Events exposing (onClick)


type Property msg
    = Label String
    | Remove (Maybe msg)
    | OtherAttr (List (Attribute msg))



---- CONFIG ----


type alias Config msg =
    { label : String
    , removeClick : Maybe msg
    , otherAttr : List (Attribute msg)
    }


defaultConfig : Config msg
defaultConfig =
    { label = ""
    , removeClick = Nothing
    , otherAttr = []
    }



---- Property Functions ----


{-| Label for chips
-}
label : String -> Property msg
label data =
    Label data


{-| Remove msg for input chip
-}
removeClick : msg -> Property msg
removeClick val =
    Remove (Just val)


{-| additional attributes for chips
-}
extraAttributes : List (Attribute msg) -> Property msg
extraAttributes val =
    OtherAttr val



---- View ----


{-| view function for chips
-}
view : List (Property msg) -> Html msg
view properties =
    let
        config =
            fetchConfig properties
    in
    div
        (Attr.class "mdc-chip"
            :: config.otherAttr
        )
        [ div
            [ Attr.class "mdc-chip__text" ]
            [ text config.label ]
        , case config.removeClick of
            Just msg ->
                i
                    [ Attr.class "mdc-chip__icon material-icons mdc-chip__icon--trailing"
                    , Attr.tabindex 0
                    , Attr.attribute "role" "button"
                    , onClick msg
                    ]
                    [ text "cancel" ]

            Nothing ->
                text ""
        ]


fetchConfig : List (Property msg) -> Config msg
fetchConfig properties =
    List.foldl propToConfig defaultConfig properties


propToConfig : Property msg -> Config msg -> Config msg
propToConfig prop config =
    case prop of
        Label val ->
            { config | label = val }

        Remove val ->
            { config | removeClick = val }

        OtherAttr val ->
            { config | otherAttr = val }
