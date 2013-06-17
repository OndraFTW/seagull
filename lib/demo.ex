defmodule Demo do
  import Widget
  
  def button() do
    f=frame :f, 'This is frame', size: {700, 700}, position: {50, 50}, react: [:closed] do
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
          button :H, label: 'This button\nreacts on click.', react: [:clicked]
        end
      end
    end

    pid=WindowProcess.start f
    
    button_reaction pid

  end

  def button_reaction(pid) do
    cont=receive do
      {^pid, :f, :closed}->IO.puts 'You closed frame.';pid<-:destroy;false
      {^pid, :H, :clicked}->IO.puts 'You clicked on button.';true
    end
    if cont, do: button_reaction pid
  end

end
