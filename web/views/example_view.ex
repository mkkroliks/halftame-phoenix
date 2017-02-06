defmodule Halftame.ExampleView do
  use Halftame.Web, :view

  def render("index.json", %{examples: examples}) do
    %{data: render_many(examples, Halftame.ExampleView, "example.json")}
  end

  def render("show.json", %{example: example}) do
    %{data: render_one(example, Halftame.ExampleView, "example.json")}
  end

  def render("example.json", %{example: example}) do
    %{id: example.id,
      name: example.name}
  end
end
