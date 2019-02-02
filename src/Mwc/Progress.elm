module Mwc.Progress exposing (extraAttributes, progressBar, progressSpinner, view)

{-| Material Progress. It is elm wrapper for Polymer Web components paper progress bar and paper progress spinner
Used Elm-css for Styling

@docs extraAttributes, progressBar, progressSpinner, view

-}

import Html.Styled exposing (Attribute, Html, node, text)
import Html.Styled.Attributes as Attr
import Json.Encode as Encode


type Property msg
    = ProgressBar Bool
    | ProgressSpinner Bool
    | OtherAttr (List (Attribute msg))



---- CONFIG ----


type alias Config msg =
    { progressBar : Bool
    , progressSpinner : Bool
    , otherAttr : List (Attribute msg)
    }


defaultConfig : Config msg
defaultConfig =
    { progressBar = False
    , progressSpinner = False
    , otherAttr = []
    }



---- Property Functions ----


{-| display progressBar
-}
progressBar : Property msg
progressBar =
    ProgressBar True


{-| displays progressSpinner
-}
progressSpinner : Property msg
progressSpinner =
    ProgressSpinner True


{-| Additional properties like css
-}
extraAttributes : List (Attribute msg) -> Property msg
extraAttributes otherAttr =
    OtherAttr otherAttr



---- View ----


{-| Renders progress bar/spiner
-}
view : List (Property msg) -> Html msg
view properties =
    let
        config =
            fetchConfig properties
    in
    if config.progressBar then
        node "paper-progress"
            (Attr.property "indeterminate" (Encode.bool config.progressBar)
                :: config.otherAttr
            )
            []

    else if config.progressSpinner then
        node "paper-spinner-lite"
            (Attr.property "active" (Encode.bool config.progressSpinner)
                :: config.otherAttr
            )
            []

    else
        text ""


fetchConfig : List (Property msg) -> Config msg
fetchConfig properties =
    List.foldl propToConfig defaultConfig properties


propToConfig : Property msg -> Config msg -> Config msg
propToConfig prop config =
    case prop of
        ProgressBar val ->
            { config | progressBar = val }

        ProgressSpinner val ->
            { config | progressSpinner = val }

        OtherAttr val ->
            { config | otherAttr = val }
