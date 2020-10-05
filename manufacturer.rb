# frozen_string_literal: true

# set manufacturer
module Manufacturer
  def stamp_manufacturer(name = '')
    name.is_a?(String) ? self.manufacturer = name : 'ERROR: invalid data type'
  end

  protected

  attr_accessor :manufacturer
end
