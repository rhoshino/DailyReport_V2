module UsersHelper

  def init_value(array)
    str = ""
    array.each do |a|
      unless str == ""
        str+="\n"
      end
      str += a
    end
    str
  end

end
