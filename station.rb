require_relative 'instanceCounter'

# Класс Station (Станция):

class Station

  include InstanceCounter

  attr_reader :trains, :station_name

  # метод класса, который позволит вывести все созданные станции
  @@stations = []

  init_count

  def self.all
    @@stations
  end

  # Имеет название, которое указывается при ее создании

  def initialize(station_name)
    @station_name = station_name
    @trains = []
    @@stations << self

    register_instance
  end

  # Может принимать поезда (по одному за раз)

  def add_train(train)
    @trains << train
  end

  # Может возвращать список всех поездов на станции, находящиеся в текущий момент
  # --- есть attr_reader на :trains, снёс метод show_trains
  # Может возвращать список поездов на станции по типу (см. ниже): кол-во
  # грузовых, пассажирских

  #--- убрал puts-ы, создал хэш

  def show_trains_by_type
    @cargo =  @trains.count { |train| train.type == 'cargo'}
    @passenger =  @trains.count { |train| train.type == 'passenger'}
    @trains_by_type = {
      cargo: @cargo,
      passenger: @passenger
    }
  end

  # Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка
  # поездов, находящихся на станции).

  def departure(train)
    @trains.delete(train)
  end
end
