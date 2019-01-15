module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text, input, table, tr, td)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)
import Round


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { totalText : String
    , serviceFeeText : String
    , hoi : Int
    }


init : Model
init =
    Model "" "" 1



-- UPDATE


type Msg
    = ChangeServiceFee String
    | ChangeTotal String
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Decrement ->
            { model | hoi = model.hoi + 1 }

        ChangeServiceFee value ->
            { model | serviceFeeText = value }

        ChangeTotal value ->
            { model | totalText = value }



-- VIEW


view : Model -> Html Msg
view model =
    let
        total =
            Maybe.withDefault 0 (String.toFloat model.totalText)

        serviceFee =
            Maybe.withDefault 0 (String.toFloat model.serviceFeeText)

        host =
            total - serviceFee

        round = Round.round 2

        ratio = 0.8

        vat = 0.21

        huisvestigingskosten = serviceFee / ( 1 + vat ) * vat * ratio

        vorderingOmzetbelasting = (total * ratio) - huisvestigingskosten

    in
        div []
            [ div [] [ text "Airbnb privé-zakelijk calculator" ]
            , div [] [ text "Service fee" ]
            , input [ placeholder "Service fee", value model.serviceFeeText, onInput ChangeServiceFee ] []
            , div [] [ text "Total" ]
            , input [ placeholder "Total", value model.totalText, onInput ChangeTotal ] []
            , table []
                [ tr []
                    [ td [] [ text "" ]
                    , td [] [ text "Privé -> zakelijk" ]
                    ]
                , tr []
                    [ td [] [ text "Vordering omzetbelasting" ]
                    , td [] [ text <| round <| vorderingOmzetbelasting ]
                    ]
                , tr []
                    [ td [] [ text "Huisvestingskosten" ]
                    , td [] [ text <| round <| huisvestigingskosten ]
                    ]
                , tr []
                    [ td [] [ text "Total" ]
                    , td [] [ text <| round <| total * ratio ]
                    ]
                , tr []
                    [ td [] [ text "" ]
                    , td [] [ text "" ]
                    ]
                , tr []
                    [ td [] [ text "" ]
                    , td [] [ text "Zakelijk" ]
                    ]
                , tr []
                    [ td [] [ text "Host" ]
                    , td [] [ text <| round <| (total - serviceFee) ]
                    ]
                , tr []
                    [ td [] [ text "Service fee" ]
                    , td [] [ text <| round <| serviceFee ]
                    ]
                , tr []
                    [ td [] [ text "Total" ]
                    , td [] [ text <| round <| total ]
                    ]
                ]
            ]
