# frozen_string_literal: true

# meta
module InstanceCounter
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  # init counter
  module ClassMethods
    attr_writer :counter

    def counter
      @counter ||= 0
    end
  end

  # increment for objects
  module InstanceMethods
    protected

    def register_instance
      self.class.counter += 1
    end
  end
end
