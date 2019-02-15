module Mwc.Table exposing (tbody, td, tfoot, th, thead, tr, view)

{-| Matrial design Table
-}

import Css exposing (..)
import Css.Global
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr



---- PROPERTIES ----


type Tr msg
    = Th (List Style) (List (Html msg))
    | Td (List Style) (List (Html msg))


type Trow msg
    = Tr (List Style) (List (Tr msg))


type Property msg
    = Thead (List Style) (List (Trow msg))
    | Tbody (List Style) (List (Trow msg))
    | Tfoot (List Style) (List (Trow msg))



---- CONFIG ----


type alias Config msg =
    { tHead : ( List Style, List (Trow msg) )
    , tBody : ( List Style, List (Trow msg) )
    , tFoot : ( List Style, List (Trow msg) )
    }


defaultConfig : Config msg
defaultConfig =
    { tHead = ( [], [] )
    , tBody = ( [], [] )
    , tFoot = ( [], [] )
    }



---- Property Functions ----


{-| Material design table head
-}
thead : List Style -> List (Trow msg) -> Property msg
thead css tableRow =
    Thead css tableRow


{-| Material design table row
-}
tr : List Style -> List (Tr msg) -> Trow msg
tr css tableData =
    Tr css tableData


{-| Material design table head
-}
th : List Style -> List (Html msg) -> Tr msg
th css tableHead =
    Th css tableHead


{-| Material design table body
-}
tbody : List Style -> List (Trow msg) -> Property msg
tbody css tableHead =
    Tbody css tableHead


{-| Material design table data
-}
td : List Style -> List (Html msg) -> Tr msg
td css tableHead =
    Td css tableHead


{-| Material design table foot
-}
tfoot : List Style -> List (Trow msg) -> Property msg
tfoot css tableHead =
    Tfoot css tableHead



---- VIEW ----


{-| Material design table
-}
view : List Style -> List (Property msg) -> Html msg
view style properties =
    let
        config =
            fetchConfig properties
    in
    Html.table
        [ Attr.css <|
            Css.batch
                [ width (pct 100)
                , paddingLeft (px 16)
                , paddingRight (px 16)
                , backgroundColor (rgb 255 255 255)
                , borderCollapse collapse
                ]
                :: style
        ]
        [ Html.thead
            [ Attr.css <|
                textTransform capitalize
                    :: Tuple.first config.tHead
            ]
            (Tuple.second config.tHead
                |> List.map fetchRow
            )
        , Html.tbody
            [ Attr.css <|
                (Css.Global.children
                    [ Css.Global.typeSelector "tr"
                        [ hover
                            [ backgroundColor (hex "eee") ]
                        ]
                    ]
                    :: Tuple.first config.tBody
                )
            ]
            (Tuple.second config.tBody
                |> List.map fetchRow
            )
        , Html.tfoot
            [ Attr.css <|
                Tuple.first config.tFoot
            ]
            (Tuple.second config.tFoot
                |> List.map fetchRow
            )
        ]


fetchConfig : List (Property msg) -> Config msg
fetchConfig properties =
    List.foldl propToConfig defaultConfig properties


propToConfig : Property msg -> Config msg -> Config msg
propToConfig prop config =
    case prop of
        Thead style tRow ->
            { config | tHead = ( style, tRow ) }

        Tbody style tRow ->
            { config | tBody = ( style, tRow ) }

        Tfoot style tRow ->
            { config | tBody = ( style, tRow ) }


fetchRow : Trow msg -> Html msg
fetchRow row =
    case row of
        Tr style data ->
            Html.tr
                [ Attr.css <|
                    borderBottom3 (px 1) solid (rgba 0 0 0 0.12)
                        :: style
                ]
                (List.map fetchColumnData data)


fetchColumnData : Tr msg -> Html msg
fetchColumnData data =
    case data of
        Th style html ->
            Html.th
                [ Attr.css <|
                    Css.batch
                        [ height (px 48)
                        , fontFamilies [ "Roboto", "sans-serif" ]
                        , fontSize (px 12)
                        , color (rgba 0 0 0 0.6)
                        ]
                        :: style
                ]
                html

        Td style html ->
            Html.td
                [ Attr.css <|
                    Css.batch
                        [ height (px 47)
                        , fontFamilies [ "Roboto", "sans-serif" ]
                        , fontSize (px 14)
                        , color (rgba 0 0 0 0.87)
                        ]
                        :: style
                ]
                html
