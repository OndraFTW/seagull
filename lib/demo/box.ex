defmodule Demo.Box do

  @moduledoc"Contains demos."

  import Widget
  import Seagull

  #
  # BOX DEMO
  #

  def start()do
    f=frame :f, "This is frame", react: [:close], size: {700, 500} do
      box :vertical, id: :vbox do
        box :horizontal, id: :hbox do
          button :A, label: "Prepend button", react: [:click]
          button :B, label: "Append button", react: [:click]
          button :C, label: "Prepend line", react: [:click]
          button :D, label: "Append line", react: [:click]
        end
      end
    end

    pid=WindowProcess.start f

    reaction pid

  end

  def reaction(pid)do
    continue=true
    receive_event do
      from pid: ^pid do
        from widget: :f, do: (:close->pid<-:destroy; continue=false)
        from widget: :A, do: (:click->send pid, :hbox, :prepend, button(:_, label: "P"))
        from widget: :B, do: (:click->send pid, :hbox, :append, button(:_, label: "A"))
        from widget: :C, do: (:click->send pid, :vbox, :prepend, box(:horizontal, do: button(:_, label: "PL")))
        from widget: :D, do: (:click->send pid, :vbox, :append, box(:horizontal, do: button(:_, label: "AL")))
      end
    end
    if continue, do: reaction pid
  end

end
