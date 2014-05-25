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
    {:button,    0, false},
    {:frame,     0, true},
    {:box,       1, true},
    {:text_box,  0, false},
    {:menu_bar,  0, true},
    {:menu,      1, true},
    {:menu_item, 1, false}
  ]

  for {widget, compulsory, children} <- @widgets do
    case {compulsory, children} do
      {0, false}->
        defmacro unquote(widget)(options\\[]) do
          widget=unquote widget
          {idi, options}=do_id_options options
          quote do: {unquote(widget), {unquote(idi)}, unquote(options), []}
        end
      {0, true}->
        defmacro unquote(widget)(options\\[], children\\[]) do
          widget=unquote widget
          {options, children}=do_options_children options, children
          {idi, options}=do_id_options options
          quote do: {unquote(widget), {unquote(idi)}, unquote(options), unquote(children)}
        end
      {1, false}->
        defmacro unquote(widget)(a, options\\[]) do
          widget=unquote widget
          {idi, options}=do_id_options options
          quote do: {unquote(widget), {unquote(idi), unquote(a)}, unquote(options), []}
        end
      {1, true}->
        defmacro unquote(widget)(a, options\\[], children\\[]) do
          widget=unquote widget
          {options, children}=do_options_children options, children
          {idi, options}=do_id_options options
          quote do: {unquote(widget), {unquote(idi), unquote(a)}, unquote(options), unquote(children)}
        end
    end
  end

  def get_widget_from_tree({type, req, options, children}, id) when elem(req, 0)==id, do: {type, req, options, children}
  def get_widget_from_tree({_type, _req, _options, []}, _id), do: nil
  def get_widget_from_tree({_type, _req, _options, children}, id) do
    get_widget_from_list children, id
  end

  defp get_widget_from_list([], _id), do: nil
  defp get_widget_from_list([head|tail], id) do
    r=get_widget_from_tree head, id
    if r==nil do
      get_widget_from_list tail, id
    else
      r
    end
  end

  def modify_tree(tree, id, function) do
    {true, new_tree}=modify_widget_in_tree tree, id, function
    new_tree
  end

  defp modify_widget_in_tree({type, req, options, children}, id, function) when elem(req, 0)==id do
    {true, function.({type, req, options, children})}
  end
  defp modify_widget_in_tree({type, req, options, []}, _id, _function) do
    {false, {type, req, options, []}}
  end
  defp modify_widget_in_tree({type, req, options, children}, id, function) do
    {r, new_children}=modify_widget_in_list children, id, function, []
    {r, {type, req, options, new_children}}
  end

  defp modify_widget_in_list([], _id, _function, result) do
    {false, Enum.reverse(result)}
  end
  defp modify_widget_in_list([head|tail], id, function, result) do
    r=modify_widget_in_tree head, id, function
    case r do
      {true, widget}->{true, Enum.reverse(result)++[widget|tail]}
      {false, widget}->modify_widget_in_list(tail, id, function, [widget|result])
    end
  end

end
