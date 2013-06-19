defmodule WindowProcess.Box do
  require Constant

  def respond(object, :get_orientation, []) do
    o = :wxBoxSizer.getOrientation Keyword.get(object, :wxobject)
    case o do
      Constant.wxVERTICAL->:vertical
      Constant.wxHORIZONTAL->:horizontal
    end
  end
  def respond(object, func, options),
    do: WindowProcess.Sizer.respond object, func, options

end
