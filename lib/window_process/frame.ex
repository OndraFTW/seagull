defmodule WindowProcess.Frame do

  def respond(object, func, options), do: WindowProcess.TopLevelWindow.respond object, func, options

end
