defmodule Widget do

  def eval_children([]), do: []
  def eval_children([item]), do: [quote do: unquote(item)]
  def eval_children([head|tail]), do: [quote(do: unquote(head))|eval_children(tail)]
  def eval_children(item), do: [quote do: unquote(item)]

  defrecord Button, id: :_, options: []
  defmacro button(options//[]) do
    if Keyword.has_key?(options, :id) do
      idi=Keyword.get options, :id
      options=Keyword.delete options, :id
    else
      idi=:_
    end
    quote do: Widget.Button.new id: unquote(idi), options: unquote(options)
  end

  defrecord Frame, id: nil, title: "", options: [], children: []
  defmacro frame(options//[], children//[]) do
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
    if Keyword.has_key?(options, :id) do
      idi=Keyword.get options, :id
      options=Keyword.delete options, :id
    else
      idi=:_
    end
    if Keyword.has_key?(options, :title) do
      titlei=Keyword.get options, :title
      options=Keyword.delete options, :title
    else
      titlei=""
    end
    quote do: Widget.Frame.new id: unquote(idi), title: unquote(titlei), options: unquote(options), children: unquote(children)
  end
  
  defrecord Box, id: :_, orientation: nil, options: [], children: []
  defmacro box(orientation, options//[], children//[]) do
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
    if Keyword.has_key?(options, :id) do
      idi=Keyword.get options, :id
      options=Keyword.delete options, :id
    else
      idi=:_
    end
    quote do: Widget.Box.new id: unquote(idi), orientation: unquote(orientation), options: unquote(options), children: unquote(children)
  end

  defrecord TextBox, id: :_, options: []
  defmacro text_box(options//[]) do
    if Keyword.has_key?(options, :id) do
      idi=Keyword.get options, :id
      options=Keyword.delete options, :id
    else
      idi=:_
    end
    quote do: Widget.TextBox.new id: unquote(idi), options: unquote(options)
  end

  defrecord MenuBar, id: :_, options: [], children: []
  defmacro menu_bar(options//[], children//[]) do
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
    if Keyword.has_key?(options, :id) do
      idi=Keyword.get options, :id
      options=Keyword.delete options, :id
    else
      idi=:_
    end
    quote do: Widget.MenuBar.new id: unquote(idi), options: unquote(options), children: unquote(children)
  end

  defrecord Menu, id: :_, title: "", options: [], children: []
  defmacro menu(title, options//[], children//[]) do
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
    if Keyword.has_key?(options, :id) do
      idi=Keyword.get options, :id
      options=Keyword.delete options, :id
    else
      idi=:_
    end
    quote do: Widget.Menu.new id: unquote(idi), title: unquote(title), options: unquote(options), children: unquote(children)
  end

  defrecord MenuItem, id: :_, title: "", options: []
  defmacro menu_item(title, options//[]) do
    if Keyword.has_key?(options, :id) do
      idi=Keyword.get options, :id
      options=Keyword.delete options, :id
    else
      idi=:_
    end
    quote do: Widget.MenuItem.new id: unquote(idi), title: unquote(title), options: unquote(options)
  end

end
