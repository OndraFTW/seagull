defmodule Event.MenuItem do

  def react(data, :select) do
    my_pid=self
    id=Keyword.get data, :id
    pid=Keyword.get data, :pid
    {:wx_ref, wx_id, :wxMenuItem, _}=Keyword.get data, :wxobject
    :wxEvtHandler.connect Keyword.get(data, :wxparent), :command_menu_selected, [{:id, wx_id}, {:callback, fn(_, _)-> pid<-[my_pid, id, :select];IO.puts("XX") end}]
    true
  end
  def react(_button, _id, _event, _pid), do: false

end
