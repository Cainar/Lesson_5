# frozen_string_literal: true

# set manufacturer
module Manufacturer
  def set_manufacturer(name = '')
    name.is_a?(String) ? self.manufacturer = name : 'ERROR: invalid data type'
  end

  def get_manufacturer
    @manufacturer
  end

  protected

  attr_accessor :manufacturer
end
