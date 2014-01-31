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

  lc {widget, compulsory, children} inlist @widgets do
    case {compulsory, children} do
      {0, false}->
        defmacro unquote(widget)(options//[]) do
          widget=unquote widget
          {idi, options}=do_id_options options
          quote do: {unquote(widget), {unquote(idi)}, unquote(options), []}
        end
      {0, true}->
        defmacro unquote(widget)(options//[], children//[]) do
          widget=unquote widget
          {options, children}=do_options_children options, children
          {idi, options}=do_id_options options
          quote do: {unquote(widget), {unquote(idi)}, unquote(options), unquote(children)}
        end
      {1, false}->
        defmacro unquote(widget)(a, options//[]) do
          widget=unquote widget
          {idi, options}=do_id_options options
          quote do: {unquote(widget), {unquote(idi), unquote(a)}, unquote(options), []}
        end
      {1, true}->
        defmacro unquote(widget)(a, options//[], children//[]) do
          widget=unquote widget
          {options, children}=do_options_children options, children
          {idi, options}=do_id_options options
          quote do: {unquote(widget), {unquote(idi), unquote(a)}, unquote(options), unquote(children)}
        end
    end
  end

end
