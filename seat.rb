#создает место пассажирского вагона

class Seat
  # показывает занято ли место или нет.
  attr_accessor :occupancy
  # что-то вроде уникального ключа,  на всякий случай.
  attr_reader :id

  def initialize
    @id = self.object_id.to_s
    @occupancy = false
  end

  # занять место
  def take
    @occupancy = true
  end

  # освободить место
  def leave
    @occupancy = false
  end
end
