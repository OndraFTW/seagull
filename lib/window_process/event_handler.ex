defmodule WindowProcess.EventHandler do

  def respond(object, :react, {event, pid}) do
    type=Keyword.get object, :type
    wxobject=Keyword.get object, :wxobject
    id=Keyword.get object, :id
    case type do
      :button->Event.Button.react wxobject, id, event, pid
      :box->Event.Box.react wxobject, id, event, pid
      :frame->Event.Frame.react wxobject, id, event, pid
    end
  end
  def respond(object, :react, event), do: respond object, :react, {event, Keyword.get(object, :pid)}
  def respond(object, funct, options), do: WindowProcesss.Object.respond object, funct, options

end
