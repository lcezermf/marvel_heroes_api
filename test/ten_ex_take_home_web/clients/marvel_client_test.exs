defmodule TenExTakeHomeWeb.Clients.MarvelClientTest do
  use TenExTakeHomeWeb.ConnCase, async: true

  import Mox

  alias TenExTakeHome.Heroes.APIRequest
  alias TenExTakeHome.Repo
  alias TenExTakeHomeWeb.Clients.MarvelClient

  setup :verify_on_exit!

  describe "get_characters/0" do
    test "must return {:ok, results} where results is a list of data" do
      assert Repo.aggregate(APIRequest, :count) == 0

      response_body = Jason.encode!(fake_raw_response_with_list_of_characters())

      expect(http_client(), :get, fn _ ->
        {:ok, %HTTPoison.Response{body: response_body, status_code: 200}}
      end)

      {:ok, [result | _] = results} = MarvelClient.get_characters()

      assert Repo.aggregate(APIRequest, :count) == 1
      assert Repo.one(APIRequest, limit: 1).url =~ "/characters"

      assert length(results) == 1
      assert result["name"] == "3-D Man"
    end

    test "must return {:error, map()} when request is wrong" do
      assert Repo.aggregate(APIRequest, :count) == 0

      response_body =
        Jason.encode!(%{
          code: "MissingParameter",
          message: "You must provide a timestamp."
        })

      expect(http_client(), :get, fn _ ->
        {:error, %HTTPoison.Response{body: response_body, status_code: 409}}
      end)

      assert Repo.aggregate(APIRequest, :count) == 0

      {:error, response} = MarvelClient.get_characters()

      assert response.status_code == 409
      assert Jason.decode!(response.body)["code"] == "MissingParameter"
      assert Jason.decode!(response.body)["message"] == "You must provide a timestamp."
    end
  end

  describe "get_character/1" do
    test "must return {:ok, result} where result is a single record" do
      assert Repo.aggregate(APIRequest, :count) == 0

      response_body = Jason.encode!(fake_raw_response_with_single_character())

      expect(http_client(), :get, fn _ ->
        {:ok, %HTTPoison.Response{body: response_body, status_code: 200}}
      end)

      {:ok, result} = MarvelClient.get_character(1_009_144)

      assert Repo.aggregate(APIRequest, :count) == 1
      assert Repo.one(APIRequest, limit: 1).url =~ "/characters/#{result["id"]}"
      assert result["name"] == "A.I.M."
    end

    test "must return {:error, map()} when request is wrong" do
      assert Repo.aggregate(APIRequest, :count) == 0

      response_body =
        Jason.encode!(%{
          code: "MissingParameter",
          message: "You must provide a timestamp."
        })

      expect(http_client(), :get, fn _ ->
        {:error, %HTTPoison.Response{body: response_body, status_code: 409}}
      end)

      assert Repo.aggregate(APIRequest, :count) == 0

      {:error, response} = MarvelClient.get_characters()

      assert response.status_code == 409
      assert Jason.decode!(response.body)["code"] == "MissingParameter"
      assert Jason.decode!(response.body)["message"] == "You must provide a timestamp."
    end
  end

  defp http_client, do: Application.get_env(:ten_ex_take_home, :http_client)

  defp fake_raw_response_with_list_of_characters do
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

  defp fake_raw_response_with_single_character do
    %{
      "code" => 200,
      "status" => "Ok",
      "copyright" => "© 2024 MARVEL",
      "attributionText" => "Data provided by Marvel. © 2024 MARVEL",
      "attributionHTML" =>
        "<a href=\"http://marvel.com\">Data provided by Marvel. © 2024 MARVEL</a>",
      "etag" => "98d4adb7dc9531e2137c6028705d3832f1944522",
      "data" => %{
        "offset" => 0,
        "limit" => 20,
        "total" => 1,
        "count" => 1,
        "results" => [
          %{
            "id" => 1_009_144,
            "name" => "A.I.M.",
            "description" => "AIM is a terrorist organization bent on destroying the world.",
            "modified" => "2013-10-17T14:41:30-0400",
            "thumbnail" => %{
              "path" => "http://i.annihil.us/u/prod/marvel/i/mg/6/20/52602f21f29ec",
              "extension" => "jpg"
            },
            "resourceURI" => "http://gateway.marvel.com/v1/public/characters/1009144",
            "comics" => %{
              "available" => 53,
              "collectionURI" => "http://gateway.marvel.com/v1/public/characters/1009144/comics",
              "items" => [
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/36763",
                  "name" => "Ant-Man & Wasp (2010) #3"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/17553",
                  "name" => "Avengers (1998) #67"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/7340",
                  "name" => "Avengers (1963) #87"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/4214",
                  "name" => "Avengers and Power Pack Assemble! (2006) #2"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/63217",
                  "name" => "Avengers and Power Pack (2017) #3"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/63218",
                  "name" => "Avengers and Power Pack (2017) #4"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/63219",
                  "name" => "Avengers and Power Pack (2017) #5"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/63220",
                  "name" => "Avengers and Power Pack (2017) #6"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/64790",
                  "name" =>
                    "AVENGERS BY BRIAN MICHAEL BENDIS: THE COMPLETE COLLECTION VOL. 2 TPB (Trade Paperback)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/103371",
                  "name" => "Avengers Unlimited Infinity Comic (2022) #17"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/1170",
                  "name" => "Avengers Vol. 2: Red Zone (Trade Paperback)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/1214",
                  "name" => "Avengers Vol. II: Red Zone (Trade Paperback)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/12787",
                  "name" => "Captain America (1998) #28"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/7513",
                  "name" => "Captain America (1968) #132"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/7514",
                  "name" => "Captain America (1968) #133"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/65466",
                  "name" => "Captain America by Mark Waid, Ron Garney & Andy Kubert (Hardcover)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/20367",
                  "name" => "Defenders (1972) #57"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/31068",
                  "name" => "Incredible Hulks (2010) #606 (VARIANT)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/46168",
                  "name" => "Indestructible Hulk (2012) #3"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/43944",
                  "name" => "Iron Man (2012) #1"
                }
              ],
              "returned" => 20
            },
            "series" => %{
              "available" => 36,
              "collectionURI" => "http://gateway.marvel.com/v1/public/characters/1009144/series",
              "items" => [
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/13082",
                  "name" => "Ant-Man & Wasp (2010 - 2011)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/1991",
                  "name" => "Avengers (1963 - 1996)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/354",
                  "name" => "Avengers (1998 - 2004)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/23123",
                  "name" => "Avengers and Power Pack (2017)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/1046",
                  "name" => "Avengers and Power Pack Assemble! (2006)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/27689",
                  "name" =>
                    "AVENGERS BY BRIAN MICHAEL BENDIS: THE COMPLETE COLLECTION VOL. 2 TPB (2017)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/35600",
                  "name" => "Avengers Unlimited Infinity Comic (2022 - 2023)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/227",
                  "name" => "Avengers Vol. 2: Red Zone (2003)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/271",
                  "name" => "Avengers Vol. II: Red Zone (2003)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/1996",
                  "name" => "Captain America (1968 - 1996)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/1997",
                  "name" => "Captain America (1998 - 2002)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/23810",
                  "name" => "Captain America by Mark Waid, Ron Garney & Andy Kubert (2017)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/3743",
                  "name" => "Defenders (1972 - 1986)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/8842",
                  "name" => "Incredible Hulks (2010 - 2011)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/16583",
                  "name" => "Indestructible Hulk (2012 - 2014)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/2029",
                  "name" => "Iron Man (1968 - 1996)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/16593",
                  "name" => "Iron Man (2012 - 2014)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/23915",
                  "name" => "Iron Man Epic Collection: Doom (2018)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/9718",
                  "name" => "Marvel Adventures Super Heroes (2010 - 2012)"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/1506",
                  "name" => "MARVEL MASTERWORKS: CAPTAIN AMERICA (2005)"
                }
              ],
              "returned" => 20
            },
            "stories" => %{
              "available" => 57,
              "collectionURI" => "http://gateway.marvel.com/v1/public/characters/1009144/stories",
              "items" => [
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/10253",
                  "name" => "When the Unliving Strike",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/10255",
                  "name" => "Cover #10255",
                  "type" => "cover"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/10256",
                  "name" => "The Enemy Within!",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/10259",
                  "name" => "Death Before Dishonor!",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/10261",
                  "name" => "Cover #10261",
                  "type" => "cover"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/10262",
                  "name" => "The End of A.I.M.!",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/11921",
                  "name" => "The Red Skull Lives!",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/11930",
                  "name" => "He Who Holds the Cosmic Cube",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/11936",
                  "name" => "The Maddening Mystery of the Inconceivable Adaptoid!",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/11981",
                  "name" => "If This Be... Modok",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/11984",
                  "name" => "A Time to Die -- A Time to Live!",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/11995",
                  "name" => "At the Mercy of the Maggia",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/28233",
                  "name" => "In Sin Airy X",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/28971",
                  "name" => "[The Brothers Part I]",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/34426",
                  "name" => "The Red Skull Lives!",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/34435",
                  "name" => "He Who Holds the Cosmic Cube",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/34441",
                  "name" => "The Maddening Mystery of the Inconceivable Adaptoid!",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/34486",
                  "name" => "If This Be... Modok",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/34489",
                  "name" => "A Time to Die -- A Time to Live!",
                  "type" => "interiorStory"
                },
                %{
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/34500",
                  "name" => "At the Mercy of the Maggia",
                  "type" => "interiorStory"
                }
              ],
              "returned" => 20
            },
            "events" => %{
              "available" => 0,
              "collectionURI" => "http://gateway.marvel.com/v1/public/characters/1009144/events",
              "items" => [],
              "returned" => 0
            },
            "urls" => [
              %{
                "type" => "detail",
                "url" =>
                  "http://marvel.com/characters/77/aim.?utm_campaign=apiRef&utm_source=91f5d1d5b0209ba9bba6086f01263b39"
              },
              %{
                "type" => "wiki",
                "url" =>
                  "http://marvel.com/universe/A.I.M.?utm_campaign=apiRef&utm_source=91f5d1d5b0209ba9bba6086f01263b39"
              },
              %{
                "type" => "comiclink",
                "url" =>
                  "http://marvel.com/comics/characters/1009144/aim.?utm_campaign=apiRef&utm_source=91f5d1d5b0209ba9bba6086f01263b39"
              }
            ]
          }
        ]
      }
    }
  end
end
