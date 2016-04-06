defmodule Clipboard do

  def get do
    { contents, _ } = System.cmd("pbpaste", [])
    contents
  end

  def put(content) do
    File.write!(".clipboard.txt", content)
    :os.cmd('pbcopy < .clipboard.txt')
    content
  end

end
