defmodule Demo.Frame do
  import Seagull
  import Widget

  def start() do
    f=frame :frame, "A", react: [:close, :create, :maximize, :minimize] do
      box :horizontal do
        button :title_button, label: "Add 'a' to the title", react: [:click]
        button :maximize_button, label: "Maximize", react: [:click]
        button :minimize_button, label: "Minimize", react: [:click]
        button :status_button, label: "Status", react: [:click]
      end
    end
    pid=WindowProcess.spawn f
    reaction pid
  end

  def reaction(pid) do
    continue=true
    receive_event do
      from pid: ^pid do
        from widget: :frame do
          :close->
            pid<-:destroy
            continue=false
          :create->IO.puts "Frame was created."
          #:destroy->IO.puts "Frame was destroyed"
          :maximize->IO.puts "Frame was maximized."
          :minimize->IO.puts "Frame was minimized"
        end
        from widget: :title_button do
          :click->
            title=get pid, :frame, :title
            set pid, :frame, :title, title<>"a"
        end
        from widget: :maximize_button, do: (:click->send pid, :frame, :maximize)
        from widget: :minimize_button, do: (:click->send pid, :frame, :minimize)
        from widget: :status_button do
          :click->
            maxi=send pid, :frame, :is_maximized
            IO.puts "Frame #{if maxi, do: "is", else: "is not"} maximized."
            mini=send pid, :frame, :is_minimized
            IO.puts "Frame #{if mini, do: "is", else: "is not"} minimized."
        end
      end
      message do
        a->IO.inspect a
      end
    end
    if continue, do: reaction pid
  end

end