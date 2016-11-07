import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.App as Html
import P_1_0 exposing (..)
import Mouse

type alias Model = 
    { example: Example
    , p1: P_1_0.Model
    }

type Msg 
    = MouseMsg Mouse.Position
    | SelectP1
    
type Example 
    = None 
    | P_1_0

init : (Model, Cmd Msg)
init = 
    (
        { example=None
        , p1=P_1_0.init 0 15
        }
    , Cmd.none
    )

main : Program Never
main =
  Html.program 
    { init = init
    , view = view
    , subscriptions = subscriptions
    , update = update 
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseMsg pos ->            
            case model.example of
                None ->
                    (model, Cmd.none)
                P_1_0 ->
                    let 
                        (updateModel, updateCmd) = 
                            P_1_0.update (P_1_0.MouseMsg pos) model.p1
                    in
                        ({model|p1=updateModel}, updateCmd)
        SelectP1 ->
            ({model|example=P_1_0}, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Mouse.moves MouseMsg

view : Model -> Html Msg
view model =
    let
        ex = 
            case model.example of
                None ->
                    div [] [text "Select an example"]
                P_1_0 ->
                    P_1_0.view model.p1
    in                    
        div [ class "container-fluid" ] 
            [ div [class "row"] 
                [ div [class "col-md-2"] [ ul [] 
                    [ li [] [ a [onClick SelectP1] [text "P.1.0"] ] ]
                ]
                , div [class "col-md-8"] [ ex ]
                ]
            ]
