defmodule Demo.Calc do
  import Seagull
  import Widget

  require Enum
  require String

  def start() do
    f=frame :main_frame, "Calculator", size: {200,250}, react: [:close] do
      box :vertical do
        text_box :display, value: "0", size: {200,50}, text_align: :right, readonly: true
        box :horizontal do
          button :_7, label: "7", size: {50,50}, react: [:click]
          button :_8, label: "8", size: {50,50}, react: [:click]
          button :_9, label: "9", size: {50,50}, react: [:click]
          button :add, label: "+", size: {50,50}, react: [:click]
        end
        box :horizontal do
          button :_4, label: "4", size: {50,50}, react: [:click]
          button :_5, label: "5", size: {50,50}, react: [:click]
          button :_6, label: "6", size: {50,50}, react: [:click]
          button :sub, label: "-", size: {50,50}, react: [:click]
        end
        box :horizontal do
          button :_1, label: "1", size: {50,50}, react: [:click]
          button :_2, label: "2", size: {50,50}, react: [:click]
          button :_3, label: "3", size: {50,50}, react: [:click]
          button :mul, label: "*", size: {50,50}, react: [:click]
        end
        box :horizontal do
          button :clr, label: "Clr", size: {50,50}, react: [:click]
          button :_0, label: "0", size: {50,50}, react: [:click]
          button :eq, label: "=", size: {50,50}, react: [:click]
          button :div, label: "/", size: {50,50}, react: [:click]
        end
      end
    end
    pid=WindowProcess.spawn f
    reaction pid, 0, :add
  end

  def reaction(pid, acc, op) do
    continue=true
    receive_event do
      from pid: ^pid do
        from widget: :main_frame do
          :close->
            pid<-:destroy
            continue=false
        end
        from widget: :clr do
          :click->
            acc=0
            op=:add
            send pid, :display, :set_value, "0"
        end
        from widget: w do
          :click->
            if Enum.member?([:add, :sub, :mul, :div, :eq], w) do
              value=send(pid, :display, :get_value) |> binary_to_integer
              acc=case op do
                :add->acc+value
                :sub->acc-value
                :mul->acc*value
                :div->if value==0, do: 0, else: div acc, value
              end
              if w == :eq do
                send pid, :display, :set_value, integer_to_binary(acc)
                acc=0
                op=:add
              else
                send pid, :display, :set_value, "0"
                op=w
              end
            else
              value=concat_numbers send(pid, :display, :get_value), (w |> atom_to_binary |> String.last)
              send pid, :display, :set_value, value
            end
        end
      end
    end
    if continue, do: reaction pid, acc, op
  end

  def concat_numbers("0", b), do: b
  def concat_numbers(a, b), do: a<>b

end
