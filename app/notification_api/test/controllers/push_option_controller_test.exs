defmodule NotificationApi.PushOptionControllerTest do
  use NotificationApi.ConnCase

  alias NotificationApi.PushOption
  @valid_attrs %{push_id: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, push_option_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    push_option = Repo.insert! %PushOption{}
    conn = get conn, push_option_path(conn, :show, push_option)
    assert json_response(conn, 200)["data"] == %{"id" => push_option.id,
      "push_id" => push_option.push_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, push_option_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, push_option_path(conn, :create), push_option: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(PushOption, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, push_option_path(conn, :create), push_option: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    push_option = Repo.insert! %PushOption{}
    conn = put conn, push_option_path(conn, :update, push_option), push_option: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(PushOption, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    push_option = Repo.insert! %PushOption{}
    conn = put conn, push_option_path(conn, :update, push_option), push_option: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    push_option = Repo.insert! %PushOption{}
    conn = delete conn, push_option_path(conn, :delete, push_option)
    assert response(conn, 204)
    refute Repo.get(PushOption, push_option.id)
  end
end
