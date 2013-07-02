defmodule Demo.Box do

  @moduledoc"Contains demos."

  import Widget
  import Seagull

  #
  # BOX DEMO
  #

  def start()do
    f=frame :main_frame, "This is frame", react: [:close], size: {700, 500} do
      box :vertical, id: :vbox do
        box :horizontal, id: :hbox do
          button :prepend_button, label: "Prepend button", react: [:click]
          button :append_button, label: "Append button", react: [:click]
          button :prepend_line_button, label: "Prepend line", react: [:click]
          button :append_line_button, label: "Append line", react: [:click]
        end
      end
    end

    pid=WindowProcess.spawn f

    reaction pid

  end

  def reaction(pid)do
    continue=true
    receive_event do
      from pid: ^pid do
        from widget: :main_frame, do: (:close->pid<-:destroy; continue=false)
        from widget: :prepend_button, do: (:click->send pid, :hbox, :prepend, button(:_, label: "P"))
        from widget: :append_button,  do: (:click->send pid, :hbox, :append, button(:_, label: "A"))
        from widget: :prepend_line_button, do: (:click->send pid, :vbox, :prepend, box(:horizontal, do: button(:_, label: "PL")))
        from widget: :append_line_button,  do: (:click->send pid, :vbox, :append, box(:horizontal, do: button(:_, label: "AL")))
      end
    end
    if continue, do: reaction pid
  end

end
