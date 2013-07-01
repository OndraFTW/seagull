defmodule WindowProcess.TextBox do

  def respond(object, :append_text, options) do
    :wxTextCtrl.appendText Keyword.get(object, :wxobject), binary_to_list(options)
  end
  def respond(object, :can_copy, []), do: :wxTextCtrl.canCopy Keyword.get(object, :wxobject)
  def respond(object, :can_cut, []), do: :wxTextCtrl.canCut Keyword.get(object, :wxobject)
  def respond(object, :can_paste, []), do: :wxTextCtrl.canPaste Keyword.get(object, :wxobject)
  def respond(object, :can_redo, []), do: :wxTextCtrl.canRedo Keyword.get(object, :wxobject)
  def respond(object, :can_undo, []), do: :wxTextCtrl.canUndo Keyword.get(object, :wxobject)
  def respond(object, :clear, []), do: :wxTextCtrl.clear Keyword.get(object, :wxobject)
  def respond(object, :copy, []), do: :wxTextCtrl.copy Keyword.get(object, :wxobject)
  def respond(object, :cut, []), do: :wxTextCtrl.cut Keyword.get(object, :wxobject)
  def respond(object, :paste, []), do: :wxTextCtrl.paste Keyword.get(object, :wxobject)
  def respond(object, :redo, []), do: :wxTextCtrl.redo Keyword.get(object, :wxobject)
  def respond(object, :undo, []), do: :wxTextCtrl.undo Keyword.get(object, :wxobject)
  def respond(object, :get_value, []), do: list_to_binary :wxTextCtrl.getValue(Keyword.get(object, :wxobject))
  def respond(object, :set_value, value), do: :wxTextCtrl.setValue Keyword.get(object, :wxobject), binary_to_list(value)
  def respond(object, func, options),
    do: WindowProcess.Control.respond object, func, options

end
