defmodule Mix.Tasks.Minion do
  use Mix.Task

  @shortdoc "Prints help information for minion tasks"

  def run(_) do
    line_break

    Mix.shell.info [:green, "Available tasks:"]
    line_break
    Mix.Task.run("help", ["--search", "minion."])
    line_break
  end

  def line_break(), do: Mix.shell.info ""
end
