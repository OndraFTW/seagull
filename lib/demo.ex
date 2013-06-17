defmodule Demo do
  import Widget
  
  def button() do
    f=frame :f, 'This is frame', size: {700, 700}, position: {50, 50}, react: [:close, :mouse_left_down] do
      box :vertical do
        box :horizontal do
          button :A, label: 'This button is\ntop aligned.', size: {130, 130}, align: :top
          button :B, label: 'This button is\nbottom aligned.', size: {130, 130}, align: :bottom
          button :C, label: 'This button is\nright aligned.', size: {130, 130}, align: :right
          button :D, label: 'This button is\nleft aligned.', size: {130, 130}, align: :left
        end
        box :horizontal do
          button :E, label: 'This button is\ndisabled.', disabled: true
          button :F, label: 'This button is\ndefault.', default: true
          button :G, label: 'This button\nfits exactly.', style: :exact_fit
        end
        box :horizontal do
          button :H, label: 'This button\nreacts on clicks.', react: [:click]
          button :I, label: 'This button reacts\non mouse down clicks.', react: [:mouse_left_down, :mouse_right_down, :mouse_middle_down]
        end
      end
    end

    pid=WindowProcess.start f
    
    button_reaction pid

  end

  defp button_reaction(pid) do
    cont=receive do
      {^pid, :f, :close}->IO.puts 'You closed frame.';pid<-:destroy;false
      {^pid, :f, :mouse_left_down}->IO.puts "You clicked on frame.";true
      {^pid, :H, :click}->IO.puts 'You clicked on button.';true
      {^pid, :I, :mouse_left_down}->IO.puts 'Your left mouse button is down.';true
      {^pid, :I, :mouse_right_down}->IO.puts 'Your right mouse button is down.';true
      {^pid, :I, :mouse_middle_down}->IO.puts 'Your middle mouse button is down.';true
    end
    if cont, do: button_reaction pid
  end

end
