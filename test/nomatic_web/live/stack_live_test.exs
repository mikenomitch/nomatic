defmodule NomaticWeb.StackLiveTest do
  use NomaticWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Nomatic.Accounts

  @create_attrs %{
    client_count: 42,
    consul_address: "some consul_address",
    consul_version: "some consul_version",
    max_clients: 42,
    nomad_address: "some nomad_address",
    nomad_version: "some nomad_version",
    provider: "some provider",
    region: "some region",
    server_count: 42,
    state_bucket: "some state_bucket",
    status: "some status",
    token: "some token",
    type: "some type",
    use_consul: true,
    use_vault: true,
    vault_address: "some vault_address",
    vault_version: "some vault_version"
  }
  @update_attrs %{
    client_count: 43,
    consul_address: "some updated consul_address",
    consul_version: "some updated consul_version",
    max_clients: 43,
    nomad_address: "some updated nomad_address",
    nomad_version: "some updated nomad_version",
    provider: "some updated provider",
    region: "some updated region",
    server_count: 43,
    state_bucket: "some updated state_bucket",
    status: "some updated status",
    token: "some updated token",
    type: "some updated type",
    use_consul: false,
    use_vault: false,
    vault_address: "some updated vault_address",
    vault_version: "some updated vault_version"
  }
  @invalid_attrs %{
    client_count: nil,
    consul_address: nil,
    consul_version: nil,
    max_clients: nil,
    nomad_address: nil,
    nomad_version: nil,
    provider: nil,
    region: nil,
    server_count: nil,
    state_bucket: nil,
    status: nil,
    token: nil,
    type: nil,
    use_consul: nil,
    use_vault: nil,
    vault_address: nil,
    vault_version: nil
  }

  defp fixture(:stack) do
    {:ok, stack} = Accounts.create_stack(@create_attrs)
    stack
  end

  defp create_stack(_) do
    stack = fixture(:stack)
    %{stack: stack}
  end

  describe "Index" do
    setup [:create_stack]

    test "lists all stacks", %{conn: conn, stack: stack} do
      {:ok, _index_live, html} = live(conn, Routes.stack_index_path(conn, :index))

      assert html =~ "Listing Stacks"
      assert html =~ stack.consul_address
    end

    test "saves new stack", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.stack_index_path(conn, :index))

      assert index_live |> element("a", "New Stack") |> render_click() =~
               "New Stack"

      assert_patch(index_live, Routes.stack_index_path(conn, :new))

      assert index_live
             |> form("#stack-form", stack: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#stack-form", stack: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.stack_index_path(conn, :index))

      assert html =~ "Stack created successfully"
      assert html =~ "some consul_address"
    end

    test "updates stack in listing", %{conn: conn, stack: stack} do
      {:ok, index_live, _html} = live(conn, Routes.stack_index_path(conn, :index))

      assert index_live |> element("#stack-#{stack.id} a", "Edit") |> render_click() =~
               "Edit Stack"

      assert_patch(index_live, Routes.stack_index_path(conn, :edit, stack))

      assert index_live
             |> form("#stack-form", stack: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#stack-form", stack: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.stack_index_path(conn, :index))

      assert html =~ "Stack updated successfully"
      assert html =~ "some updated consul_address"
    end

    test "deletes stack in listing", %{conn: conn, stack: stack} do
      {:ok, index_live, _html} = live(conn, Routes.stack_index_path(conn, :index))

      assert index_live |> element("#stack-#{stack.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#stack-#{stack.id}")
    end
  end

  describe "Show" do
    setup [:create_stack]

    test "displays stack", %{conn: conn, stack: stack} do
      {:ok, _show_live, html} = live(conn, Routes.stack_index_path(conn, :show, stack))

      assert html =~ "Show Stack"
      assert html =~ stack.consul_address
    end

    test "updates stack within modal", %{conn: conn, stack: stack} do
      {:ok, show_live, _html} = live(conn, Routes.stack_index_path(conn, :show, stack))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Stack"

      assert_patch(show_live, Routes.stack_index_path(conn, :edit, stack))

      assert show_live
             |> form("#stack-form", stack: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#stack-form", stack: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.stack_index_path(conn, :show, stack))

      assert html =~ "Stack updated successfully"
      assert html =~ "some updated consul_address"
    end
  end
end
