# frozen_string_literal: true

# module add validations for input from user
module Validation
  # if validate raise exeption return true,
  def valid?(parameter, method = nil, length = nil, parameter_format = nil)
    validate!(parameter, method, length, parameter_format)
    true
  rescue StandardError
    false
  end

  protected

  # raise exeption deprnding on validation type
  def validate!(parameter, method = nil, length = nil, parameter_format = nil)
    raise err_title('nil') if parameter.nil?
    raise err_title('length', method, length) if !length.nil? && verification_method(parameter, method, length)
    raise err_title('format') if !parameter_format.nil? && parameter !~ parameter_format
  end

  # check string length
  def verification_method(parameter, method, limit)
    case method
    when 'less'
      parameter.length < limit
    when 'more'
      (parameter.length > limit) || parameter.empty?
    else true
    end
  end

  # set error message depending on error type
  def err_title(type, method = nil, size = nil, parameter_format = nil)
    case type
    when 'nil' then "Parameter can't be nil"
    when 'length' then "Parameter should be not #{method} #{size} symbols"
    when 'format' then "Format shoul be #{parameter_format}"
    else 'undefined'
    end
  end
end
