defmodule DemoWeb.TrackLiveTest do
  use DemoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Demo.CatalogFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_track(_) do
    track = track_fixture()
    %{track: track}
  end

  describe "Index" do
    setup [:create_track]

    test "lists all tracks", %{conn: conn, track: track} do
      {:ok, _index_live, html} = live(conn, ~p"/tracks")

      assert html =~ "Listing Tracks"
      assert html =~ track.name
    end

    test "saves new track", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/tracks")

      assert index_live |> element("a", "New Track") |> render_click() =~
               "New Track"

      assert_patch(index_live, ~p"/tracks/new")

      assert index_live
             |> form("#track-form", track: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#track-form", track: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tracks")

      html = render(index_live)
      assert html =~ "Track created successfully"
      assert html =~ "some name"
    end

    test "updates track in listing", %{conn: conn, track: track} do
      {:ok, index_live, _html} = live(conn, ~p"/tracks")

      assert index_live |> element("#tracks-#{track.id} a", "Edit") |> render_click() =~
               "Edit Track"

      assert_patch(index_live, ~p"/tracks/#{track}/edit")

      assert index_live
             |> form("#track-form", track: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#track-form", track: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tracks")

      html = render(index_live)
      assert html =~ "Track updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes track in listing", %{conn: conn, track: track} do
      {:ok, index_live, _html} = live(conn, ~p"/tracks")

      assert index_live |> element("#tracks-#{track.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tracks-#{track.id}")
    end
  end

  describe "Show" do
    setup [:create_track]

    test "displays track", %{conn: conn, track: track} do
      {:ok, _show_live, html} = live(conn, ~p"/tracks/#{track}")

      assert html =~ "Show Track"
      assert html =~ track.name
    end

    test "updates track within modal", %{conn: conn, track: track} do
      {:ok, show_live, _html} = live(conn, ~p"/tracks/#{track}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Track"

      assert_patch(show_live, ~p"/tracks/#{track}/show/edit")

      assert show_live
             |> form("#track-form", track: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#track-form", track: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/tracks/#{track}")

      html = render(show_live)
      assert html =~ "Track updated successfully"
      assert html =~ "some updated name"
    end
  end
end
