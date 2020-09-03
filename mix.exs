defmodule ExHeap.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :ex_heap,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      package: package(),
      docs: [
        main: "readme",
        extras: ["README.md"],
        source_url: "https://github.com/dhanson358/ex_heap",
        source_ref: @version
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.13 or ~> 1.0"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      maintainers: ["David Hanson <david@dhanson.org>"],
      licenses: ["MIT"],
      links: %{GitHub: "https://github.com/dhanson358/ex_heap"}
    ]
  end
end
