defmodule PushManager.Mixfile do
  use Mix.Project

  def project do
    [app: :push_manager,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :gcm, :httpoison, :ecto, :mariaex, :apns],
     mod: {PushManager, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:poison, "~> 1.5"},
      {:httpoison, "~> 0.8.0"},
      {:exactor, "~> 2.2"},
      {:amqp, "~> 0.1.3"},
      {:gcm, "~> 1.1"},
      {:apns, "== 0.0.10"},
      {:ecto, "~> 1.0"},
      {:mariaex, "~> 0.4.2"} 
    ]
  end
end
