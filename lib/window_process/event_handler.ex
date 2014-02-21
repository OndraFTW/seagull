defmodule WindowProcess.EventHandler do

  def respond(object, :react, {event, pid}), do: Event.react(Keyword.put(object, :pid, pid), event)
  def respond(object, :react, event), do: respond(object, :react, {event, Keyword.get(object, :pid)})
  def respond(object, :dont_react, event), do: Event.dont_react(object, event)
  def respond(object, funct, options), do: WindowProcess.Object.respond(object, funct, options)

end
