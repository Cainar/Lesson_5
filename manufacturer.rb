#модуль позволяет устанавливать название компании-производителя

module Manufacturer
  def set_manufacturer(name = "")
    #устанавливает имя если тип строка иначе выводит сообщение об ошибке
    name.is_a?(String) ? self.manufacturer = name : "ERROR: invalid data type"
  end

  def get_manufacturer
    @manufacturer
  end

  protected

  attr_accessor :manufacturer
end
