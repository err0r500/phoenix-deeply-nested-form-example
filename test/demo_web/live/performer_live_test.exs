defmodule DemoWeb.PerformerLiveTest do
  use DemoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Demo.CatalogFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_performer(_) do
    performer = performer_fixture()
    %{performer: performer}
  end

  describe "Index" do
    setup [:create_performer]

    test "lists all performers", %{conn: conn, performer: performer} do
      {:ok, _index_live, html} = live(conn, ~p"/performers")

      assert html =~ "Listing Performers"
      assert html =~ performer.name
    end

    test "saves new performer", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/performers")

      assert index_live |> element("a", "New Performer") |> render_click() =~
               "New Performer"

      assert_patch(index_live, ~p"/performers/new")

      assert index_live
             |> form("#performer-form", performer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#performer-form", performer: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/performers")

      html = render(index_live)
      assert html =~ "Performer created successfully"
      assert html =~ "some name"
    end

    test "updates performer in listing", %{conn: conn, performer: performer} do
      {:ok, index_live, _html} = live(conn, ~p"/performers")

      assert index_live |> element("#performers-#{performer.id} a", "Edit") |> render_click() =~
               "Edit Performer"

      assert_patch(index_live, ~p"/performers/#{performer}/edit")

      assert index_live
             |> form("#performer-form", performer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#performer-form", performer: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/performers")

      html = render(index_live)
      assert html =~ "Performer updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes performer in listing", %{conn: conn, performer: performer} do
      {:ok, index_live, _html} = live(conn, ~p"/performers")

      assert index_live |> element("#performers-#{performer.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#performers-#{performer.id}")
    end
  end

  describe "Show" do
    setup [:create_performer]

    test "displays performer", %{conn: conn, performer: performer} do
      {:ok, _show_live, html} = live(conn, ~p"/performers/#{performer}")

      assert html =~ "Show Performer"
      assert html =~ performer.name
    end

    test "updates performer within modal", %{conn: conn, performer: performer} do
      {:ok, show_live, _html} = live(conn, ~p"/performers/#{performer}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Performer"

      assert_patch(show_live, ~p"/performers/#{performer}/show/edit")

      assert show_live
             |> form("#performer-form", performer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#performer-form", performer: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/performers/#{performer}")

      html = render(show_live)
      assert html =~ "Performer updated successfully"
      assert html =~ "some updated name"
    end
  end
end
