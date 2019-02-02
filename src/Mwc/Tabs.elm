module Mwc.Tabs exposing (extraAttributes, onClick, scrollable, selected, tabText, view)

{-| Material Tabs. It is elm wrapper for Polymer Web components paper tabs
Used Elm-css for Styling

@docs extraAttributes, onClick, scrollable, selected, tabText, view

-}

import Html.Styled exposing (Attribute, Html, node, text)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as HtmlEvents
import Json.Encode as Encode


type Property msg
    = TabText (List String)
    | Scrollable Bool
    | TabSelect Int
    | OtherAttr (List (Attribute msg))
    | OnClick (Maybe (Int -> msg))



---- CONFIG ----


type alias Config msg =
    { tabText : List String
    , scrollable : Bool
    , tabSelect : Int
    , otherAttr : List (Attribute msg)
    , onClick : Maybe (Int -> msg)
    }


defaultConfig : Config msg
defaultConfig =
    { tabText = []
    , scrollable = False
    , tabSelect = 0
    , otherAttr = []
    , onClick = Nothing
    }



---- Property Functions ----


{-| List of tab texts
-}
tabText : List String -> Property msg
tabText texts =
    TabText texts


{-| Make tabs Scrollable
-}
scrollable : Property msg
scrollable =
    Scrollable True


{-| Initialies selects given tab
-}
selected : Int -> Property msg
selected val =
    TabSelect val


{-| Additional properties like css
-}
extraAttributes : List (Attribute msg) -> Property msg
extraAttributes otherAttr =
    OtherAttr otherAttr


{-| OnClick Event
-}
onClick : (Int -> msg) -> Property msg
onClick val =
    OnClick (Just val)



---- View ----


{-| Renders Tabs
-}
view : List (Property msg) -> Html msg
view properties =
    let
        config =
            fetchConfig properties
    in
    node "paper-tabs"
        ([ Attr.property "selected" (Encode.int config.tabSelect)
         , Attr.property "scrollable" (Encode.bool config.scrollable)
         , Attr.property "fitContainer" (Encode.bool config.scrollable)

         -- , Attr.css [ property "--paper-tab-ink" "#6200ee" ]
         ]
            ++ config.otherAttr
        )
        (List.indexedMap
            (\index tabTitle ->
                node "paper-tab"
                    [ fetchOnClick index config.onClick ]
                    [ text tabTitle ]
            )
            config.tabText
        )


fetchOnClick : Int -> Maybe (Int -> msg) -> Attribute msg
fetchOnClick index message =
    case message of
        Nothing ->
            Attr.class ""

        Just msg ->
            HtmlEvents.onClick (msg index)


fetchConfig : List (Property msg) -> Config msg
fetchConfig properties =
    List.foldl propToConfig defaultConfig properties


propToConfig : Property msg -> Config msg -> Config msg
propToConfig prop config =
    case prop of
        TabText texts ->
            { config | tabText = texts }

        Scrollable val ->
            { config | scrollable = val }

        TabSelect val ->
            { config | tabSelect = val }

        OtherAttr val ->
            { config | otherAttr = val }

        OnClick val ->
            { config | onClick = val }
