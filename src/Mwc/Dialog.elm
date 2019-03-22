module Mwc.Dialog exposing (actionBar, body, extraAttributes, title, view, Visibility, visible, hidden, visibility, fullScreen)

{-| Material Dialog. It is elm wrapper for Ploymer Paper--Dialog Component
Used Elm-css for Styling

@docs actionBar, body, extraAttributes, title, view, Visibility, visible, hidden, visibility, fullScreen

-}

import Css exposing (..)
import Css.Global
import Html.Styled exposing (Attribute, Html, div, h2, node, span, text)
import Html.Styled.Attributes as Attr
import Json.Encode as Encode


type Property msg
    = Title String
    | Body (List (Html msg))
    | Opened Visibility
    | ActionBar (List (Html msg))
    | FullScreen Bool
    | OtherAttr (List (Attribute msg))


{-| Visibility option
-}
type Visibility
    = Visible
    | Hidden



---- CONFIG ----


type alias Config msg =
    { title : String
    , body : List (Html msg)
    , opened : Visibility
    , actionBar : List (Html msg)
    , fullScreen : Bool
    , otherAttr : List (Attribute msg)
    }


defaultConfig : Config msg
defaultConfig =
    { title = ""
    , body = []
    , opened = Hidden
    , actionBar = []
    , fullScreen = False
    , otherAttr = []
    }



---- Property  Functions ----


{-| Makes dialog visible
-}
visible : Visibility
visible =
    Visible


{-| Makes dialog hidden
-}
hidden : Visibility
hidden =
    Hidden


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
visibility : Visibility -> Property msg
visibility val =
    Opened val


{-| Additional properties like css
-}
extraAttributes : List (Attribute msg) -> Property msg
extraAttributes val =
    OtherAttr val


{-| Make dialog FullScreen
-}
fullScreen : Property msg
fullScreen =
    FullScreen True



---- View ----


{-| renders the dialog
-}
view : List (Property msg) -> Html msg
view properties =
    let
        config =
            fetchConfig properties
    in
    span
        []
        [ node "paper-dialog"
            (fetchProperties config)
            [ h2
                [ Attr.css
                    [ textAlign start
                    , color (rgba 0 0 0 0.87)
                    , paddingLeft (px 24)
                    , fontFamilies [ "Roboto" ]
                    , fontSize (px 20)
                    , color (rgba 0 0 0 0.87)
                    , marginTop (px 24)
                    ]
                ]
                [ text config.title ]
            , div
                [ Attr.css
                    [ paddingBottom (px 28)
                    , color (rgba 0 0 0 0.6)
                    , textAlign start
                    , overflow auto
                    , if config.fullScreen then
                        Css.batch
                            [ maxHeight (calc (vh 100) minus (px 116))
                            , boxSizing borderBox
                            ]

                      else
                        maxHeight (px 570)
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
        , if config.opened == Visible then
            div
                [ Attr.css
                    [ position fixed
                    , top (px 0)
                    , left (px 0)
                    , width (vw 100)
                    , height (vh 100)
                    , backgroundColor (rgba 0 0 0 0.6)
                    , zIndex (int 102)
                    ]
                ]
                []

          else
            text ""
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

        FullScreen val ->
            { config | fullScreen = val }

        OtherAttr val ->
            { config | otherAttr = val }


fetchProperties : Config msg -> List (Attribute msg)
fetchProperties config =
    [ case config.opened of
        Visible ->
            Attr.property "opened" (Encode.bool True)

        Hidden ->
            Attr.property "opened" (Encode.bool False)
    , Attr.attribute "no-cancel-on-outside-click" ""
    , Attr.attribute "no-cancel-on-esc-key" ""
    , Attr.css
        [ borderRadius (px 4)
        , if config.fullScreen then
            Css.batch
                [ maxWidth (pct 100)
                , maxHeight (pct 100)
                ]

          else
            width (px 560)
        ]
    ]
        ++ config.otherAttr
