class Object

  def digup_write(msg, response_type=nil)
    Digup.response_type = response_type if response_type
    Digup.log(msg)
  end

  def set_digup_response(response_type)
    Digup.response_type = response_type
  end

  alias :digup_log :digup_write

end
