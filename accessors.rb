# rubocop:disable Lint/Syntax

module Accessors
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  module ClassMethods
    # create getters & setters
    def attr_accessor_with_history(*attributes)
      attributes.each do |attribute|
        attribute_array = "@#{attribute}_array"
        var_name = "@#{attribute}"

        define_method(attribute) { instance_variable_get(var_name) }

        define_method("#{attribute}=".to_sym) do |value|
          instance_variable_set(var_name, value)
          # keeping all values of instance variable for changing
          instance_variable_set(attribute_array, []) if instance_variable_get(attribute_array).nil?
          instance_variable_get(attribute_array) << value
        end

        define_method("#{attribute}_history".to_sym) do
          instance_variable_get(attribute_array)
        end
      end
    end

    def strong_attr_accessor(**attributes)
      attributes.each do |attribute, type|
        var_name = "@#{attribute}"
        define_method(attribute) { instance_variable_get(var_name) }
        define_method("#{attribute}=".to_sym) do |value|
          if value.class == type
            instance_variable_set(var_name, value)
          else
            raise StandardError, "incorrect type"
          end
        rescue => e
          puts e.message
        end
      end
    end
  end

  module InstanceMethods
    #
  end
end
