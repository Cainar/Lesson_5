# frozen_string_literal: true

# rubocop:disable all

module Validation
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validates

    def validate(attribute, type, template = nil)
      validate_methods
      @validates ||= []
      @validates << [attribute, type, template]
      define_method("validate_#{type}".to_sym) do |attribute, template|
        raise StandardError, "#{type} error: #{template}" if self.class.validate_methods[type].call(attribute, template)
      end
    end

    def validate_methods
      {
        presence: proc { |attribute| attribute.nil? || attribute.empty? },
        type: proc { |attribute, template| attribute.class != template },
        format: proc { |attribute, template| attribute !~ template }
      }
    end
  end

  module InstanceMethods
    def validate!(attributes)
      # запускает все проверки (валидации), указанные в классе через метод класса validate
      # случае ошибки валидации выбрасывает исключение с сообщением о том, какая именно валидация не прошла
      attributes.each do |attribute, type, template|
        attribute = instance_variable_get("@#{attribute}")
        send("validate_#{type}".to_sym, attribute, template)
        puts "complete #{type} validate for #{attribute}"
      end
    end

    def valid?(attribute_selection)
      attribute_selection = self.class.validates.select { |attribute, type, template| attribute == attribute_selection }
      validate!(attribute_selection)
      true
    rescue StandardError => e
      puts e.message
      false
    end
  end
end

# rubocop:enable all
