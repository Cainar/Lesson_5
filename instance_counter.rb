# frozen_string_literal: true

module InstanceCounter
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :counter

    def instances
      @counter ||= 0
    end
  end

  module InstanceMethods
    protected

    def register_instance
      # увеличивает счетчик
      self.class.counter += 1
    end
  end
end
