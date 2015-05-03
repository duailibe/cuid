defmodule Cuid.Mixfile do
  use Mix.Project

  def project do
    [app: :cuid,
     version: "0.0.1",
     elixir: "~> 1.0",
     description: "Generate collision-resistant ids, in Elixir",
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
     contributors: ["Lucas Duailibe"],
     licenses: ["MIT"],
     links: %{ "GitHub" => "https://github.com/duailibe/cuid" }]
  end
end
