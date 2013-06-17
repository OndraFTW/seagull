defmodule WindowProcess.Box do
  require Constants

  def respond(object, :get_orientation, []) do
    o = :wxBoxSizer.getOrientation object
    case o do
      Constants.wxVERTICAL->:vertical
      Constants.wxHORIZONTAL->:horizontal
    end
  end
  def respond(object, func, options),
    do: WindowProcess.Sizer.respond object, func, options

end
