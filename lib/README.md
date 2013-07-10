#Parts of Seagull

##1. Defining window
Macros in Widget transform GUI description DSL into tree of records.
Example:

    #from this
    f=frame :main_frame, "Title" do
        button :b
    end
    #to this
    f=Widget.Frame[id: :main_frame, title: "Title", options: [], children: [Widget.Button[id: :b, options: []]]]

##2. Compiling into wxWidgets objects
Function compile in module Compiler compiles tree of records into list of objects.

    [main_frame:
        [type: :frame, wxobject: {:wx_ref,35,:wxFrame,[]}, id: :main_frame, pid: #PID<0.26.0>,
        wxparent: {:wx_ref,0,:wx,[]}, parent: nil],
    b:
        [type: :button, wxobject: {:wx_ref,36,:wxButton,[]}, id: :b, pid: #PID<0.26.0>,
        wxparent: {:wx_ref,35,:wxFrame,[]}, parent: :main_frame]]

##3. Processing incoming messages
Incoming messages are received in function WindowProcess.rec and than delegated to function WindowProcess.X.response.
Where X is object type.
