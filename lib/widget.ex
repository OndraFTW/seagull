defmodule Widget do

  def eval_children([]), do: []
  def eval_children([item]), do: [quote do: unquote(item)]
  def eval_children([head|tail]), do: [quote(do: unquote(head))|eval_children(tail)]
  def eval_children(item), do: [quote do: unquote(item)]

  def do_options_children(options, children) do
    if children==[] do
      children=Keyword.get options, :do, []
    else
      children=Keyword.get children, :do, []
    end
    children=case children do
      {:__block__, _, children}->children
      nil->[]
      []->[]
      child->[child]
    end
    options=Keyword.delete options, :do
    children=eval_children(children)
    {options, children}
  end

  def do_id_options(options) do
    if Keyword.has_key?(options, :id) do
      idi=Keyword.get options, :id
      options=Keyword.delete options, :id
    else
      idi=:_
    end
    {idi, options}
  end

 @widgets [
    {:button,    Widget.Button,   0, false},
    {:frame,     Widget.Frame,    0, true},
    {:box,       Widget.Box,      1, true},
    {:text_box,  Widget.TextBox,  0, false},
    {:menu_bar,  Widget.MenuBar,  0, true},
    {:menu,      Widget.Menu,     1, true},
    {:menu_item, Widget.MenuItem, 1, false}
  ]

  defrecord Button, id: :_, options: []
  defrecord Frame, id: :_, options: [], children: []
  defrecord Box, id: :_, orientation: nil, options: [], children: []
  defrecord TextBox, id: :_, options: []
  defrecord MenuBar, id: :_, options: [], children: []
  defrecord Menu, id: :_, title: "", options: [], children: []
  defrecord MenuItem, id: :_, title: "", options: []

  lc {widget, module, compulsory, has_children} inlist @widgets do
    case {compulsory, has_children} do
      {0, false}->
        defmacro unquote(widget)(options//[]) do
          modulei=unquote(module)
          {idi, options}=do_id_options options
          quote do: {unquote(modulei), unquote(idi), unquote(options)}
        end
      {0, true}->
        defmacro unquote(widget)(options//[], children//[]) do
          modulei=unquote(module)
          {options, children}=do_options_children options, children
          {idi, options}=do_id_options options
          quote do: {unquote(modulei), unquote(idi), unquote(options), unquote(children)}
        end
      {1, false}->
        defmacro unquote(widget)(a, options//[]) do
          modulei=unquote(module)
          {idi, options}=do_id_options options
          quote do: {unquote(modulei), unquote(idi), unquote(a), unquote(options)}
        end
      {1, true}->
        defmacro unquote(widget)(a, options//[], children//[]) do
          modulei=unquote(module)
          {options, children}=do_options_children options, children
          {idi, options}=do_id_options options
          quote do: {unquote(modulei), unquote(idi), unquote(a), unquote(options), unquote(children)}
        end
    end
  end

end
