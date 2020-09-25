module InstanceCounter

  module ClassMethods

    attr_accessor :counter

    def init_count
      @counter = 0
    end

    def instances
      # вернет количесвто экземпляров
      @counter
    end

  end



  module InstanceMethods

    protected

    def register_instance
      # увеличивает счетчик
      self.class.counter += 1
    end

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

end
