import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http exposing (..)
import Json.Decode as Decode

main : Program Never Model Msg
main = 
    Html.program 
        { init = init 
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }

type Msg = GetJoke | FetchJoke (Result Http.Error Joke) 

type alias Model = { quote : String }

init : (Model, Cmd Msg)
init = (Model "", fetchJokeCmd)
   
type alias Joke = { value : String }

fetchJokeCmd : Cmd Msg
fetchJokeCmd = 
    Http.send FetchJoke (Http.get "https://api.chucknorris.io/jokes/random" decodeJokeApiResponse) 

decodeJokeApiResponse : Decode.Decoder Joke
decodeJokeApiResponse =
    Decode.map Joke
        (Decode.field "value" Decode.string)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of 
        GetJoke ->
            (model, fetchJokeCmd)
        FetchJoke (Ok joke) ->
            ( { model | quote = joke.value }, Cmd.none )
        FetchJoke (Err _) ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
     div [ class "container" ] [
        h2 [ class "text-center" ] [ text "Chuck Norris Quotes" ]
        , p [ class "text-center" ] [
            button [ class "btn btn-success", onClick GetJoke ] [ text "Grab a quote!" ]
        ]
        -- Blockquote with quote
        , blockquote [] [ 
            p [] [text model.quote] 
        ]
    ]





