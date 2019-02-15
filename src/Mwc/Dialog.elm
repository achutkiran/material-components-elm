module Mwc.Dialog exposing (actionBar, body, extraAttributes, open, title, view)

{-| Material Dialog. It is elm wrapper for Ploymer Paper--Dialog Component
Used Elm-css for Styling

@docs actionBar, body, extraAttributes, open, title, view

-}

import Css exposing (..)
import Css.Global
import Html.Styled exposing (Attribute, Html, div, h2, node, text)
import Html.Styled.Attributes as Attr
import Json.Encode as Encode


type Property msg
    = Title String
    | Body (List (Html msg))
    | Opened Bool
    | ActionBar (List (Html msg))
    | OtherAttr (List (Attribute msg))



---- CONFIG ----


type alias Config msg =
    { title : String
    , body : List (Html msg)
    , opened : Bool
    , actionBar : List (Html msg)
    , otherAttr : List (Attribute msg)
    }


defaultConfig : Config msg
defaultConfig =
    { title = ""
    , body = []
    , opened = False
    , actionBar = []
    , otherAttr = []
    }



---- Property  Functions ----


{-| The title of the dialog
-}
title : String -> Property msg
title data =
    Title data


{-| List of elements to in bosy section
-}
body : List (Html msg) -> Property msg
body val =
    Body val


{-| Elements to be displayed in actionbar
-}
actionBar : List (Html msg) -> Property msg
actionBar val =
    ActionBar val


{-| Used to open the dialog
-}
open : Bool -> Property msg
open val =
    Opened val


{-| Additional properties like css
-}
extraAttributes : List (Attribute msg) -> Property msg
extraAttributes val =
    OtherAttr val



---- View ----


{-| renders the dialog
-}
view : List (Property msg) -> Html msg
view properties =
    let
        config =
            fetchConfig properties
    in
    node "paper-dialog"
        (fetchProperties config)
        [ h2
            [ Attr.css
                [ textAlign start
                , color (rgba 0 0 0 0.87)
                , paddingLeft (px 24)
                , fontFamilies [ "Roboto" ]
                , fontSize (px 20)
                , color (rgba 0 0 0 0.87)
                ]
            ]
            [ text config.title ]
        , div
            [ Attr.css
                [ paddingBottom (px 28)
                , color (rgba 0 0 0 0.6)
                , textAlign start
                ]
            ]
            config.body
        , div
            [ Attr.css
                [ displayFlex
                , flexWrap wrap
                , justifyContent flexEnd
                , margin (px 0)
                , paddingBottom (px 8)
                , paddingRight (px 8)
                , Css.Global.children
                    [ Css.Global.typeSelector "*"
                        [ paddingLeft (px 8) ]
                    ]
                ]
            ]
            config.actionBar
        ]


fetchConfig : List (Property msg) -> Config msg
fetchConfig properties =
    List.foldl propToConfig defaultConfig properties


propToConfig : Property msg -> Config msg -> Config msg
propToConfig prop config =
    case prop of
        Title data ->
            { config | title = data }

        Body val ->
            { config | body = val }

        Opened val ->
            { config | opened = val }

        ActionBar val ->
            { config | actionBar = val }

        OtherAttr val ->
            { config | otherAttr = val }


fetchProperties : Config msg -> List (Attribute msg)
fetchProperties config =
    [ Attr.property "opened" (Encode.bool config.opened)
    , Attr.property "modal" (Encode.bool True)
    , Attr.css
        [ borderRadius (px 4)
        , width (px 560)
        ]
    ]
        ++ config.otherAttr
