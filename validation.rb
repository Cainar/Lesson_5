# frozen_string_literal: true

# rubocop:disable all

module Validation
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(attribute, type, template = nil)
      @validates ||= []
      @validates << [attribute, type, template]
    end

    def validates
      @validates
    end
  end

  module InstanceMethods
    def validate!(attribute_selection = self.class.validates)
      # запускает все проверки (валидации), указанные в классе через метод класса validate
      # случае ошибки валидации выбрасывает исключение с сообщением о том, какая именно валидация не прошла
      attribute_selection.each do |attribute, type, template|
        attribute = instance_variable_get("@#{attribute}")
        case type
        when :presence
          raise StandardError, 'presence error' if attribute.nil? || attribute.empty?
        when :format
          raise StandardError, 'format error' if attribute !~ template
        when :type
          raise StandardError, 'type error' if attribute.class != template
        else
          raise StandardError, 'check type of attribute is undefined'
        end
      end
    end

    def valid?(attribute_selection = self.class.validates)
      if attribute_selection != self.class.validates
        attribute_selection = self.class.validates.select { |attribute, type, template| attribute == attribute_selection }
      end
      validate!(attribute_selection)
      true
    rescue StandardError => e
      puts e.message
      false
    end
  end
end

# rubocop:enable all
