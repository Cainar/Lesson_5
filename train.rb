# Класс Train (Поезд):

# Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
require_relative 'manufacturer'

class Train

  include Manufacturer

  # Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество
  # вагонов, эти данные указываются при создании экземпляра класса
  attr_reader :speed, :wagons, :route, :number, :type

  # Может возвращать количество вагонов

  def initialize(number = '', type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
    @route = nil
  end

  # Может набирать скорость

  def speed_up(speed)
    @speed += speed if speed > 0
  end

  # Может тормозить (сбрасывать скорость до нуля)

  def stop
    @speed = 0
  end

  # Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод
  # просто увеличивает или уменьшает количество вагонов). Прицепка/отцепка
  # вагонов может осуществляться только если поезд не движется.

  def attach(wagon)
    if @type == wagon.type && @speed == 0
      @wagons << wagon
    elsif @speed != 0
      puts "Отказано. Поезд движется!"
    else
      puts "Отказано, тип вагона не соответствует поезду!"
    end
  end

  def detach
    @wagons.delete_at(-1) if @speed == 0 && @wagons.length > 0
  end

  # Может принимать маршрут следования (объект класса Route).
  # При назначении маршрута поезду, поезд автоматически помещается на первую
  #   станцию в маршруте.

  def set_route(route)
    @route = route
    @route.start_station.add_train(self) if !@route.start_station.trains.include?(self)
  end


  # Может перемещаться между станциями, указанными в маршруте. Перемещение
  #   возможно вперед и назад, но только на 1 станцию за раз.

  def move_forward
        @route.stations.each_with_index do |station, index|
          if station.trains.include?(self) && station != @route.stations.last
            station.departure(self)
            @route.stations[index + 1].add_train(self)
            print "Предыдущая: #{@route.stations[index].station_name} " unless @route.stations[index].nil?
            print "|||Текущая: #{@route.stations[index + 1].station_name} <-- ||| "
            print "Следующая: #{@route.stations[index + 2].station_name}\n" unless @route.stations[index + 2].nil?
            break
          end
        end
  end

  def move_backward
        @route.stations.each_with_index do |station, index|
          if station.trains.include?(self) && station != @route.stations.first
            station.departure(self)
            @route.stations[index - 1].add_train(self)
            print "Следующая: #{@route.stations[index].station_name}" unless @route.stations[index].nil?
            print "|||Текущая: #{@route.stations[index - 1].station_name} <-- ||| "
            print "Предыдущая: #{@route.stations[index - 2].station_name}\n" unless index - 2 < 0
            break
          end
        end
  end

end


# Создаем класс для пассажирского и грузового поездов

class PassengerTrain < Train
  def initialize(number, type = "passenger")
    super
  end
end

class CargoTrain < Train
  def initialize(number, type = "cargo")
    super
  end
end

class Wagon

  include Manufacturer


  attr_reader :id, :type

  def initialize
    @id = self.object_id
  end
end

class CargoWagon < Wagon
  def initialize
    super
    @type = "cargo"
  end
end

class PassengerWagon < Wagon
  def initialize
    super
    @type = "passenger"
  end
end
