defmodule Demo.Button do

  @moduledoc"Contains demos."

  import Widget
  import Seagull

  #
  # BUTTON DEMO
  #

  @doc"Shows frame with different buttons."
  def start() do
    #define frame f
    f=frame id: :main_frame, size: {800, 800}, react: [:close] do
      box :vertical do
        box :horizontal do
          button label: "This button's label is\ntop aligned.", size: {200, 200}, label_align: :top
          button label: "This button's label is\nbottom aligned.", size: {200, 200}, label_align: :bottom
          button label: "This button's label is\nright aligned.", size: {200, 200}, label_align: :right
          button label: "This button's label is\nleft aligned.", size: {200, 200}, label_align: :left
        end
        box :horizontal do
          button label: "This button's label is\ntop left aligned.", size: {200, 200}, label_align: :top_left
          button label: "This button's label is\nbottom left aligned.", size: {200, 200}, label_align: :bottom_left
          button label: "This button's label is\ntop right aligned.", size: {200, 200}, label_align: :top_right
          button label: "This button's label is\nbottom right aligned.", size: {200, 200}, label_align: :bottom_right
        end
        box :horizontal do
          button label: "This button is\ndisabled.", disabled: true
          button label: "This button is\ndefault.", default: true
          button label: "This button\nfits exactly.", exact_fit: true
          button label: "This button\nhas no border", no_border: true
        end
        box :horizontal do
          button id: :click_button, label: "This button\nreacts on clicks.", react: [:click]
          button id: :count_button, label: "This button counts\nclicks: 0", react: [:click]
          button id: :grow_button, label: "This button grows\nwhen you click it.", react: [:click]
        end
        box :horizontal do
          button id: :button, label: "This button\ndoesn't do anything."
          button id: :activation_button, label: "This button activate\nbutton on the left.", react: [:click]
        end
      end
    end

    #start new GUI process with frame f
    pid=WindowProcess.spawn f
    
    #react on messages from GUI process
    reaction pid

  end

  #reactions on messages from GUI process
  defp reaction(pid) do
    continue=true
    receive_event do
      from pid: ^pid do
        from widget: :main_frame do
          :close->
            IO.puts "You closed frame."
            pid<-:destroy
            continue=false
        end
        from widget: :click_button, do: (:click->IO.puts "You clicked on button.")
        from widget: :count_button do
          :click->
            label=send pid, :count_button, :get_label
            count=Regex.run(%r/[0-9]+/, label) |> Enum.first |> binary_to_integer
            count=count+1
            label=Regex.replace %r/([0-9]+)/, label, integer_to_binary(count)
            send pid, :count_button, :set_label, label
        end
        from widget: :grow_button do
          :click->
            {w, h}=send pid, :grow_button, :get_size
            send pid, :grow_button, :set_size, {w+1, h+1}
        end
        from widget: :activation_button do 
          :click->
            send pid, :button, :react, :click
            send pid, :button, :set_label, "This button\nreacts on clicks."
        end
        from widget: :button, do: (:click->IO.puts "You clicked on activated button.")
      end
    end
    if continue, do: reaction pid
  end

end
