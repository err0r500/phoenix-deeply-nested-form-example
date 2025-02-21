defmodule DemoWeb.AdminCanCreateUserTest do
  use DemoWeb.FeatureCase, async: true

  test "admin can create user", %{conn: conn} do
    result =
      conn
      |> visit("/albums")
      |> click_link("New Album")
      |> fill_in("Album Name", with: "Aragorn")
      |> click_button("Add Track")
      |> fill_in("#album_tracks_0_name", "Track Name", with: "hello")
      |> click_button("Save Album")

    result
    |> assert_path("/albums")
    |> assert_has("td span", text: "Aragorn")
  end
end

