defmodule Compiler.Box do
  require Constant

  def compile(id, orientation, options, children, data) do
    o=case orientation do
      :vertical->Constant.wxVERTICAL
      :horizontal->Constant.wxHORIZONTAL
    end
    wxitem = :wxBoxSizer.new o
    pid=Keyword.get data, :pid
    parent=Keyword.get data, :wxparent
    compile_options(wxitem, id, options, pid)
    {:wx_ref, r, :wxSizer, []} = :wxWindow.getSizer parent
    if r==0, do: :wxWindow.setSizer parent, wxitem
    children=Compiler.compile_box_children children, [wxparent: parent, parent: id, wxbox: wxitem, pid: pid], []
    [{id, [type: :box, wxobject: wxitem, id: id]++data}|children]
  end

  
  def compile_options(_box, _id, [], _pid), do: nil

end
