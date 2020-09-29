# создаем методы для проверки вводимых данных пользователем на наличие,
# соответствие длинне и формату

module Validation

  # если validate выбросил исключение (raise exeption) то возвращает истину,
  # в протичном случае ложь
  def valid? (parameter, method = nil, length = nil, parameter_format = nil)
    validate!(parameter, method, length, parameter_format)
    true
  rescue
    false
  end

  protected


  # выбразывает (raise) исключения, в зависимости от типа проверки
  def validate!(parameter, method = nil, length = nil, parameter_format = nil)
    raise err_title("nil") if parameter.nil?
    raise err_title("length", method, length) if !length.nil? && verification_method(parameter, method, length)
    raise err_title("format") if !parameter_format.nil? && parameter !~ parameter_format
  end

  # проверяем строку на длину, либо не длинее,
  # либо не короче заданного параметра
  def verification_method(parameter, method, limit)
    case method
    when "less"
      parameter.length < limit
    when "more"
      (parameter.length > limit) || (parameter.length < 1)
    else true
    end
  end

  # получаем строку с ообщением об ошибке в зависимости от типа
  def err_title(type, method = nil, size = nil, parameter_format = nil)
    case type
    when "nil" then "Parameter can't be nil"
    when "length" then "Parameter should be not #{method} #{size} symbols"
    when "format" then "Format shoul be #{parameter_format}"
    else "undefined"
    end
  end
end
