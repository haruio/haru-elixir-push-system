defmodule NotificationApi.ServiceOptionControllerTest do
  use NotificationApi.ConnCase

  alias NotificationApi.ServiceOption
  @valid_attrs %{service_id: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, service_option_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    service_option = Repo.insert! %ServiceOption{}
    conn = get conn, service_option_path(conn, :show, service_option)
    assert json_response(conn, 200)["data"] == %{"id" => service_option.id,
      "service_id" => service_option.service_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, service_option_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, service_option_path(conn, :create), service_option: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ServiceOption, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, service_option_path(conn, :create), service_option: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    service_option = Repo.insert! %ServiceOption{}
    conn = put conn, service_option_path(conn, :update, service_option), service_option: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ServiceOption, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    service_option = Repo.insert! %ServiceOption{}
    conn = put conn, service_option_path(conn, :update, service_option), service_option: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    service_option = Repo.insert! %ServiceOption{}
    conn = delete conn, service_option_path(conn, :delete, service_option)
    assert response(conn, 204)
    refute Repo.get(ServiceOption, service_option.id)
  end
end
