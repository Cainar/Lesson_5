# Класс Train (Поезд):

# Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
require_relative 'manufacturer'
require_relative "seat"

class Train
  include Manufacturer
  include InstanceCounter

  # Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество
  # вагонов, эти данные указываются при создании экземпляра класса
  attr_reader :speed, :wagons, :route, :number, :type
  @@trains = {}

  # метод класса, выводит поезд по номеру
  def self.find(train_number)
    @@trains.has_key?(train_number) ? @@trains[train_number] : nil
  end

  instances

  def initialize(number = '', type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
    @route = nil
    @@trains[number] = self
    register_instance
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

  def each_wagon
    @wagons.each do |wagon|
      yield(wagon)
    end
  end
end


# Создаем класс для пассажирского и грузового поездов

class PassengerTrain < Train
  instances
  def initialize(number, type = "passenger")
    super
  end
end

class CargoTrain < Train
  instances
  def initialize(number, type = "cargo")
    super
  end
end

# отдельный класс вагон

class Wagon
  include Manufacturer

  attr_reader :id, :type

  def initialize(size)
    @id = self.object_id
  end
end

# грузовой вагон
class CargoWagon < Wagon
  attr_reader :volume, :cargo
  #DEFAUT_VOLUME = 1.0

  def initialize(size)
    super
    @volume = size
    @cargo = 0.0
    @type = "cargo"
  end

  def fill_wagon(cargo)
    #заполняет объем вагона, диапазон значений 0.0 - 1.0, 1.0 означает 100%
    if cargo.between?(0.0, @volume)
      @cargo += cargo
      @volume -= @cargo
    end
  end

  def show_volume
    # показывает доступный доступный объем
    @volume.round(2)
  end

  def show_freight
    # показывает объем груза
    @cargo.round(2)
  end

  private

  attr_writer :volume, :cargo
end

# пассажирский вагон
class PassengerWagon < Wagon
  # массив мест в вагоне, хранит места
  attr_accessor :seats
  #количесвто мест для базовой модификации
  #DEFAULT_SEATS_NUMBER = 10

  def initialize(size)
    super
    @type = "passenger"
    @seats = []
    #базовая модификация на 10 мест
    # заполняем вагон местами в базовой модификации (взял от балды)
    #default_version(DEFAULT_SEATS_NUMBER)
    default_version(size)
  end

  # заполняем вагон местами
  def default_version(seats_number)
    seats_number.times { @seats << Seat.new }
  end

  # занимает место по ID места
  def take_seat
    find_seat = lambda { |seat| seat.occupancy == false }
    @seats.select(&find_seat).first.take unless @seats.select(&find_seat).first.nil?
  end

  # освобождает по ID места
  def make_room
    find_seat = lambda { |seat| seat.occupancy == true }
    @seats.select(&find_seat).first.leave unless @seats.select(&find_seat).first.nil?
  end

  # показывает количество свободных мест
  def show_free_seats
    free_seat = lambda { |occupancy| occupancy == false}
    @seats.map(&:occupancy).select(&free_seat).size
  end

  #показывает количество занятых мест
  def show_taken_seats
    free_seat = lambda { |occupancy| occupancy == true}
    @seats.map(&:occupancy).select(&free_seat).size
  end
end
