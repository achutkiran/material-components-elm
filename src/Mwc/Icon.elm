module Mwc.Icon exposing (extraAttributes, iconName, view)

{-| Material Icon. It is elm wrapper for Material Web components icon
Used Elm-css for Styling

@docs extraAttributes, iconName, view

-}

import Html.Styled exposing (Attribute, Html, node, text)


type Property msg
    = IconName String
    | OtherAttr (List (Attribute msg))



---- CONFIG ----


type alias Config msg =
    { iconName : String
    , otherAttr : List (Attribute msg)
    }


defaultConfig : Config msg
defaultConfig =
    { iconName = ""
    , otherAttr = []
    }



---- Property Functions ----


{-| IconName
-}
iconName : String -> Property msg
iconName name =
    IconName name


{-| Additional properties like css
-}
extraAttributes : List (Attribute msg) -> Property msg
extraAttributes otherAttr =
    OtherAttr otherAttr



---- View ----


{-| Renders icon
-}
view : List (Property msg) -> Html msg
view properties =
    let
        config =
            fetchConfig properties
    in
    node "mwc-icon"
        config.otherAttr
        [ text config.iconName ]


fetchConfig : List (Property msg) -> Config msg
fetchConfig properties =
    List.foldl propToConfig defaultConfig properties


propToConfig : Property msg -> Config msg -> Config msg
propToConfig prop config =
    case prop of
        IconName name ->
            { config | iconName = name }

        OtherAttr val ->
            { config | otherAttr = val }
