defmodule Widget do

  def eval_children([]), do: []
  def eval_children([item]), do: [quote do: unquote(item)]
  def eval_children([head|tail]), do: [quote(do: unquote(head))|eval_children(tail)]
  def eval_children(item), do: [quote do: unquote(item)]

  def random_id(), do: quote do: :random.uniform |> float_to_binary |> binary_to_atom

  defrecord Button, id: :_, options: []
  defmacro button(id, options//[]) do
    quote do: Widget.Button.new id: unquote(id), options: unquote(options)
  end

  defrecord Frame, id: nil, title: '', options: [], children: []
  defmacro frame(id, title, options//[], children//[]) do
    if children==[] do
      children=Keyword.get options, :do, []
    else
      children=Keyword.get children, :do, []
    end
    children=case children do
      {:__block__, _, children}->children
      nil->[]
      child->[child]
    end
    options=Keyword.delete options, :do
    children=eval_children(children)
    quote do: Widget.Frame.new id: unquote(id), title: unquote(title), options: unquote(options), children: unquote(children)
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
  defmacro text_box(id, options//[]) do
    quote do: Widget.TextBox.new id: unquote(id), options: unquote(options)
  end

end
