defmodule Mix.Tasks.Minion.SlackEmojiDownload do
  use Mix.Task

  @shortdoc "Download each of the slack emojis for an org"

  def run(_) do
    HTTPoison.start
    Clipboard.get
    |> verify
    |> download_all

    Mix.shell.info [:green, "Done!"]
  end

  defp verify(contents) do
    if String.contains?(contents, ~s["emoji": {]) do
      Mix.shell.info "Found the right json in the clipboard."
      contents
    else
      Mix.shell.error "Unable to find the right json in the clipboard."
      Mix.shell.error "Copy it to the clipboard from https://api.slack.com/methods/emoji.list/test"
      exit(:normal)
    end
  end

  defp download_all(contents) do
    Poison.decode!(contents, keys: :atoms)[:emoji]
    |> Enum.chunk(10, 10, [])
    |> Enum.each(fn(list) -> parallel_retrieve(list) end)
  end

  defp download(name, url = "https" <> _rest) do
    suffix = String.slice(url, -3, 3)
    filename = "#{name}.#{suffix}"
    IO.puts "Retrieving #{url}"
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(url)
    File.write!("#{System.user_home}/Downloads/#{filename}", body)
  end

  defp download(name, _alias) do
  end

  defp parallel_retrieve(list) do
    list
    |> Enum.map(fn({name, url}) -> Task.async(fn -> download(name, url) end) end)
    |> Enum.map(&Task.await/1)
  end

end
