module Mwc.IconButton exposing
    ( disable
    , extraAttributes
    , icon
    , onClick
    , tooltip
    , view
    )

import Html.Styled exposing (Attribute, Html, node, text)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as HtmlEvents
import Json.Encode as Encode


type Property msg
    = Icon String
    | OnClick (Maybe msg)
    | ToolTip String
    | Disabled Bool
    | OtherAttr (List (Attribute msg))



---- CONFIG ----


type alias Config msg =
    { icon : String
    , onClick : Maybe msg
    , tooltip : String
    , disabled : Bool
    , otherAttr : List (Attribute msg)
    }


defaultConfig : Config msg
defaultConfig =
    { icon = ""
    , onClick = Nothing
    , tooltip = ""
    , disabled = False
    , otherAttr = []
    }



---- Property Functions ----


{-| Icon Name
-}
icon : String -> Property msg
icon name =
    Icon name


{-| onClick Event
-}
onClick : msg -> Property msg
onClick val =
    OnClick (Just val)


{-| Tooltip
-}
tooltip : String -> Property msg
tooltip val =
    ToolTip val


{-| makes icon button disabled
-}
disable : Bool -> Property msg
disable val =
    Disabled val


{-| Additional properties like css
-}
extraAttributes : List (Attribute msg) -> Property msg
extraAttributes otherAttr =
    OtherAttr otherAttr



---- View ----


{-| Renders Icon button
-}
view : List (Property msg) -> Html msg
view properties =
    let
        config =
            fetchConfig properties
    in
    node "paper-icon-button"
        ([ Attr.property "icon" (Encode.string config.icon)
         , Attr.property "title" (Encode.string config.tooltip)
         , Attr.property "disabled" (Encode.bool config.disabled)
         , case config.onClick of
            Nothing ->
                Attr.class ""

            Just msg ->
                HtmlEvents.onClick msg
         ]
            ++ config.otherAttr
        )
        []


fetchConfig : List (Property msg) -> Config msg
fetchConfig properties =
    List.foldl propToConfig defaultConfig properties


propToConfig : Property msg -> Config msg -> Config msg
propToConfig prop config =
    case prop of
        Icon name ->
            { config | icon = name }

        OnClick val ->
            { config | onClick = val }

        ToolTip val ->
            { config | tooltip = val }

        Disabled val ->
            { config | disabled = val }

        OtherAttr val ->
            { config | otherAttr = val }
