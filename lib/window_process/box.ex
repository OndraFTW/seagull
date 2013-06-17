defmodule WindowProcess.Box do

  def respond(object, func, options),
    do: WindowProcess.Sizer.respond object, func, options

end
