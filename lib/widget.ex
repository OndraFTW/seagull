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

  defrecord Button, id: :_, options: []
  defmacro button(options//[]) do
    {idi, options}=do_id_options options
    quote do: Widget.Button.new id: unquote(idi), options: unquote(options)
  end

  defrecord Frame, id: :_, options: [], children: []
  defmacro frame(options//[], children//[]) do
    {options, children}=do_options_children options, children
    {idi, options}=do_id_options options
    quote do: Widget.Frame.new id: unquote(idi), options: unquote(options), children: unquote(children)
  end
  
  defrecord Box, id: :_, orientation: nil, options: [], children: []
  defmacro box(orientation, options//[], children//[]) do
    {options, children}=do_options_children options, children
    {idi, options}=do_id_options options
    quote do: Widget.Box.new id: unquote(idi), orientation: unquote(orientation), options: unquote(options), children: unquote(children)
  end

  defrecord TextBox, id: :_, options: []
  defmacro text_box(options//[]) do
    {idi, options}=do_id_options options
    quote do: Widget.TextBox.new id: unquote(idi), options: unquote(options)
  end

  defrecord MenuBar, id: :_, options: [], children: []
  defmacro menu_bar(options//[], children//[]) do
    {options, children}=do_options_children options, children
    {idi, options}=do_id_options options
    quote do: Widget.MenuBar.new id: unquote(idi), options: unquote(options), children: unquote(children)
  end

  defrecord Menu, id: :_, title: "", options: [], children: []
  defmacro menu(title, options//[], children//[]) do
    {options, children}=do_options_children options, children
    {idi, options}=do_id_options options
    quote do: Widget.Menu.new id: unquote(idi), title: unquote(title), options: unquote(options), children: unquote(children)
  end

  defrecord MenuItem, id: :_, title: "", options: []
  defmacro menu_item(title, options//[]) do
    {idi, options}=do_id_options options
    quote do: Widget.MenuItem.new id: unquote(idi), title: unquote(title), options: unquote(options)
  end

end
