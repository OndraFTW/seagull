defmodule WindowProcess.Object do

  def respond(_object, funct, _options), do: raise {:no_response_found, funct}

end
