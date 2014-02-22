#Parts of Seagull

##1. Defining window
Macros in Widget transform GUI description DSL into tree of tuples.
Example:

    #from this
    f=frame id: :main_frame, title: "Title" do
        button id: :b
    end
    #to this
    f={:frame, {:main_frame}, [title: "Title"], [{:button, {:b}, [], []}]}

##2. Compiling into wxWidgets objects
Function compile in module Compiler compiles tree of records into keyword of objects.

    [main_frame:
        [type: :frame, wxobject: {:wx_ref, 35, :wxFrame, []},
        id: :main_frame, pid: #PID<0.56.0>, wxparent: {:wx_ref, 0, :wx, []},
        parent: nil],
    b:
        [type: :button, wxobject: {:wx_ref, 37, :wxButton, []}, id: :b,
        pid: #PID<0.56.0>, wxparent: {:wx_ref, 35, :wxFrame, []},
        parent: :main_frame]]

##3. Processing incoming messages
Incoming messages are received in function WindowProcess.rec and than delegated to function WindowProcess.X.response.
Where X is object type.
