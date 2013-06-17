defmodule Compiler.Box do
  require Constant

  def compile(id, orientation, options, children, parent, pid) do
    o=case orientation do
      :vertical->Constant.wxVERTICAL
      :horizontal->Constant.wxHORIZONTAL
    end
    wxitem = :wxBoxSizer.new o
    compile_options(wxitem, id, options, pid)
    {:wx_ref, r, :wxSizer, []} = :wxWindow.getSizer parent
    if r==0, do: :wxWindow.setSizer parent, wxitem
    children=Compiler.compile_box_children children, wxitem, parent, [], pid
    [{id, [type: :box, wxobject: wxitem]}|children]
  end

  
  def compile_options(_box, _id, [], _pid), do: nil

end
