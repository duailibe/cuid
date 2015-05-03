defmodule Cuid.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :cuid,
     version: @version,
     elixir: "~> 1.0",
     deps: deps,
     package: package,
     name: "Cuid",
     description: "Generate collision-resistant ids, in Elixir",
     docs: [readme: "README.md", main: "README",
            source_ref: "v#{@version}",
            source_url: "https://github.com/duailibe/cuid"]]
  end

  def application do
    []
  end

  defp deps do
    [{:earmark, "~> 0.1.0", only: :dev},
     {:ex_doc, "~> 0.7.0", only: :dev}]
  end

  defp package do
    [contributors: ["Lucas Duailibe"],
     licenses: ["MIT"],
     links: %{ "GitHub" => "https://github.com/duailibe/cuid" }]
  end
end
