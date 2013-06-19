defmodule Demo do

  @moduledoc"Contains demos."

  import Widget
  
  #
  # BUTTON DEMO
  #

  @doc"Shows frame with different buttons."
  def button() do
    #define frame f
    f=frame :f, "This is frame", size: {700, 700}, position: {50, 50}, react: [:close, :mouse_left_down] do
      box :vertical do
        box :horizontal do
          button :A, label: "This button is\ntop aligned.", size: {130, 130}, align: :top
          button :B, label: "This button is\nbottom aligned.", size: {130, 130}, align: :bottom
          button :C, label: "This button is\nright aligned.", size: {130, 130}, align: :right
          button :D, label: "This button is\nleft aligned.", size: {130, 130}, align: :left
        end
        box :horizontal do
          button :E, label: "This button is\ndisabled.", disabled: true
          button :F, label: "This button is\ndefault.", default: true
          button :G, label: "This button\nfits exactly.", style: :exact_fit
        end
        box :horizontal do
          button :H, label: "This button\nreacts on clicks.", react: [:click]
          button :I, label: "This button reacts\non mouse down and up clicks.", react: [:mouse_left_down, :mouse_right_down,
            :mouse_middle_down, :mouse_left_up, :mouse_right_up, :mouse_middle_up]
          button :J, label: "This button reacts\non mouse entering\nand leaving it.", react: [:mouse_enter, :mouse_leave]
        end
        box :horizontal do
          button :K, label: "This button counts\nclicks: 0", react: [:click]
          button :L, label: "This button grows\nwhen you click it.", react: [:click]
        end
      end
    end

    #start new GUI process with frame f
    pid=WindowProcess.start f
    
    #react on messages from GUI process
    button_reaction pid

  end

  #reactions on messages from GUI process
  defp button_reaction(pid) do
    cont=receive do
      {^pid, :f, :close}->IO.puts "You closed frame.";pid<-:destroy;false
      {^pid, :f, :mouse_left_down, {x, y}}->IO.puts "You clicked on frame on position [#{x}, #{y}].";true
      {^pid, :H, :click}->IO.puts "You clicked on button.";true
      {^pid, :I, :mouse_left_down, {x, y}}->IO.puts "Your left mouse button is down on position [#{x}, #{y}].";true
      {^pid, :I, :mouse_right_down, {x, y}}->IO.puts "Your right mouse button is down on position [#{x}, #{y}].";true
      {^pid, :I, :mouse_middle_down, {x, y}}->IO.puts "Your middle mouse button is down on position [#{x}, #{y}].";true
      {^pid, :I, :mouse_left_up, {x, y}}->IO.puts "Your left mouse button is up on position [#{x}, #{y}].";true
      {^pid, :I, :mouse_right_up, {x, y}}->IO.puts "Your right mouse button is up on position [#{x}, #{y}].";true
      {^pid, :I, :mouse_middle_up, {x, y}}->IO.puts "Your middle mouse button is up on position [#{x}, #{y}].";true
      {^pid, :J, :mouse_enter, {x, y}}->IO.puts "Your mouse entered button on position [#{x}, #{y}]";true
      {^pid, :J, :mouse_leave, {x, y}}->IO.puts "Your mouse left button on position [#{x}, #{y}]";true
      {^pid, :K, :click}->
        label=Seagull.get pid, :K, :label
        count=Regex.run(%r/[0-9]+/, label) |> Enum.first |> binary_to_integer
        count=count+1
        label=Regex.replace %r/([0-9]+)/, label, integer_to_binary(count)
        Seagull.set pid, :K, :label, label
        true
      {^pid, :L, :click}->
        {w, h}=Seagull.get pid, :L, :size
        Seagull.set pid, :L, :size, {w+1, h+1}
        true
    end
    if cont, do: button_reaction pid
  end

  #
  # BOX DEMO
  #

  def box()do
    f=frame :f, "This is frame", react: [:close] do
      box :horizontal, id: :box do
        button :A, label: "APPEND", react: [:click]
        button :B, label: "PREPEND", react: [:click]
      end
    end

    pid=WindowProcess.start f

    box_reaction pid

  end

  def box_reaction(pid)do
    cont=receive do
      {^pid, :f, :close}->pid<-:destroy;false
      {^pid, :A, :click}->
        Seagull.send pid, :box, :append, button(:_, label: "Appended")
      {^pid, :B, :click}->
        Seagull.send pid, :box, :prepend, button(:_, label: "Prepended")
    end
    if cont, do: box_reaction pid
  end

end
