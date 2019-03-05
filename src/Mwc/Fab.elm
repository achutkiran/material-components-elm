module Mwc.Fab exposing (disabled, extraAttributes, icon, mini, onClick, tooltip, view, src)

{-| Material FAB. It is elm wrapper for Polymer Web components Paper Floating action button
Used Elm-css for Styling

@docs disabled, extraAttributes, icon, mini, onClick, tooltip, view, src

-}

import Html.Styled exposing (Attribute, Html, node, text)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as HtmlEvents
import Json.Encode as Encode


type Property msg
    = Icon String
    | Tooltip String
    | Disabled Bool
    | Mini Bool
    | Src String
    | OnClick (Maybe msg)
    | OtherAttr (List (Attribute msg))



---- CONFIG ----


type alias Config msg =
    { icon : String
    , tooltip : String
    , disabled : Bool
    , mini : Bool
    , src : String
    , onClick : Maybe msg
    , otherAttr : List (Attribute msg)
    }


defaultConfig : Config msg
defaultConfig =
    { icon = ""
    , tooltip = ""
    , disabled = False
    , mini = False
    , src = ""
    , onClick = Nothing
    , otherAttr = []
    }



---- Property Functions ----


{-| Icon name
-}
icon : String -> Property msg
icon name =
    Icon name


{-| Tooltip
-}
tooltip : String -> Property msg
tooltip val =
    Tooltip val


{-| Disables FAB
-}
disabled : Bool -> Property msg
disabled val =
    Disabled val


{-| Reduces size of FAB
-}
mini : Property msg
mini =
    Mini True


{-| onClick Event
-}
onClick : msg -> Property msg
onClick message =
    OnClick (Just message)


{-| Svg icon src
-}
src : String -> Property msg
src val =
    Src val


{-| Additional properties like css
-}
extraAttributes : List (Attribute msg) -> Property msg
extraAttributes val =
    OtherAttr val



---- View ----


{-| Renders FAB
-}
view : List (Property msg) -> Html msg
view properties =
    let
        config =
            fetchConfig properties
    in
    node "paper-fab"
        ([ Attr.property "disabled" (Encode.bool config.disabled)
         , Attr.property "title" (Encode.string config.tooltip)
         , Attr.property "mini" (Encode.bool config.mini)
         , fetchIcon config
         , case config.onClick of
            Nothing ->
                Attr.class ""

            Just message ->
                HtmlEvents.onClick message
         ]
            ++ config.otherAttr
        )
        []


fetchConfig : List (Property msg) -> Config msg
fetchConfig properties =
    List.foldl propToConfig defaultConfig properties


propToConfig : Property msg -> Config msg -> Config msg
propToConfig property config =
    case property of
        Icon name ->
            { config | icon = name }

        Tooltip val ->
            { config | tooltip = val }

        Disabled val ->
            { config | disabled = val }

        Mini val ->
            { config | mini = val }

        OnClick message ->
            { config | onClick = message }

        Src val ->
            { config | src = val }

        OtherAttr val ->
            { config | otherAttr = val }


fetchIcon : Config msg -> Attribute msg
fetchIcon config =
    if config.src == "" then
        Attr.property "icon" (Encode.string config.icon)

    else
        Attr.property "src" (Encode.string config.src)
