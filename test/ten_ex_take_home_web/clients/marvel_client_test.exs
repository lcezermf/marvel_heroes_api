defmodule TenExTakeHomeWeb.Clients.MarvelClientTest do
  use TenExTakeHomeWeb.ConnCase, async: true

  import Mox

  alias TenExTakeHomeWeb.Clients.MarvelClient

  setup :verify_on_exit!

  describe "get_characters/0" do
    test "must return {:ok, results} where results is a list of data" do
      response_body = Jason.encode!(fake_raw_response())

      expect(http_client(), :get, fn _ ->
        {:ok, %HTTPoison.Response{body: response_body, status_code: 200}}
      end)

      {:ok, [result | _] = results} = MarvelClient.get_characters()

      assert length(results) == 1
      assert result["name"] == "3-D Man"
    end

    test "must return {:error, map()} when request is wrong" do
      response_body =
        Jason.encode!(%{
          code: "MissingParameter",
          message: "You must provide a timestamp."
        })

      expect(http_client(), :get, fn _ ->
        {:error, %HTTPoison.Response{body: response_body, status_code: 409}}
      end)

      {:error, response} = MarvelClient.get_characters()

      assert response.status_code == 409
      assert Jason.decode!(response.body)["code"] == "MissingParameter"
      assert Jason.decode!(response.body)["message"] == "You must provide a timestamp."
    end
  end

  defp http_client, do: Application.get_env(:ten_ex_take_home, :http_client)

  defp fake_raw_response do
    %{
      "code" => 200,
      "status" => "Ok",
      "data" => %{
        "offset" => 0,
        "limit" => 20,
        "total" => 1564,
        "count" => 20,
        "results" => [
          %{
            "id" => 1_011_334,
            "name" => "3-D Man",
            "description" => "",
            "modified" => "2014-04-29T14:18:17-0400",
            "thumbnail" => %{
              "path" => "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
              "extension" => "jpg"
            },
            "resourceURI" => "http://gateway.marvel.com/v1/public/characters/1011334",
            "comics" => %{
              "available" => 1,
              "collectionURI" => "http://gateway.marvel.com/v1/public/characters/1011334/comics",
              "items" => [
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/21366",
                  "name" => "Avengers => The Initiative (2007) #14"
                }
              ],
              "returned" => 1
            },
            "series" => %{
              "available" => 3,
              "collectionURI" => "http://gateway.marvel.com/v1/public/characters/1011334/series",
              "items" => [
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/1945",
                  "name" => "Avengers => The Initiative (2007 - 2010)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/2005",
                  "name" => "Deadpool (1997 - 2002)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/2045",
                  "name" => "Marvel Premiere (1972 - 1981)"
                }
              ],
              "returned" => 3
            },
            "stories" => %{
              "available" => 2,
              "collectionURI" => "http://gateway.marvel.com/v1/public/characters/1011334/stories",
              "items" => [
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/19947",
                  "name" => "Cover #19947",
                  "type" => "cover"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/19948",
                  "name" => "The 3-D Man!",
                  "type" => "interiorStory"
                }
              ],
              "returned" => 2
            },
            "events" => %{
              "available" => 1,
              "collectionURI" => "http://gateway.marvel.com/v1/public/characters/1011334/events",
              "items" => [
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/events/269",
                  "name" => "Secret Invasion"
                }
              ],
              "returned" => 1
            },
            "urls" => [
              %{
                "type" => "detail",
                "url" =>
                  "http://marvel.com/characters/74/3-d_man?utm_campaign=apiRef&utm_source=422c32a7c4c3f9adfe3f4aef0db1a1e8"
              },
              %{
                "type" => "wiki",
                "url" =>
                  "http://marvel.com/universe/3-D_Man_(Chandler)?utm_campaign=apiRef&utm_source=422c32a7c4c3f9adfe3f4aef0db1a1e8"
              },
              %{
                "type" => "comiclink",
                "url" =>
                  "http://marvel.com/comics/characters/1011334/3-d_man?utm_campaign=apiRef&utm_source=422c32a7c4c3f9adfe3f4aef0db1a1e8"
              }
            ]
          }
        ]
      }
    }
  end
end
