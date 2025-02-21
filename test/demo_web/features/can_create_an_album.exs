defmodule DemoWeb.AdminCanCreateUserTest do
  use DemoWeb.FeatureCase, async: true

  test "admin can create user", %{conn: conn} do
    album_name = "Goodbye, Hello"

    result =
      conn
      |> visit("/albums")
      |> click_link("New Album")
      |> fill_in("Album Name", with: album_name)
      |> click_button("#add-track", "Add Track")
      |> fill_in("#album_tracks_0_name", "Track Name", with: "track 1")
      |> click_button("Save Album")

    result
    |> assert_path("/albums")
    |> assert_has("td span", text: album_name)
  end
end

