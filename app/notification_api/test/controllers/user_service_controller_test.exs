defmodule NotificationApi.UserServiceControllerTest do
  use NotificationApi.ConnCase

  alias NotificationApi.UserService
  @valid_attrs %{user_seq: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_service_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user_service = Repo.insert! %UserService{}
    conn = get conn, user_service_path(conn, :show, user_service)
    assert json_response(conn, 200)["data"] == %{"id" => user_service.id,
      "user_seq" => user_service.user_seq}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, user_service_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_service_path(conn, :create), user_service: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(UserService, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_service_path(conn, :create), user_service: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user_service = Repo.insert! %UserService{}
    conn = put conn, user_service_path(conn, :update, user_service), user_service: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(UserService, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_service = Repo.insert! %UserService{}
    conn = put conn, user_service_path(conn, :update, user_service), user_service: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user_service = Repo.insert! %UserService{}
    conn = delete conn, user_service_path(conn, :delete, user_service)
    assert response(conn, 204)
    refute Repo.get(UserService, user_service.id)
  end
end
