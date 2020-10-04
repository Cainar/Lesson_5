# frozen_string_literal: true

# Class Train:
require_relative 'manufacturer'
require_relative 'seat'

class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :speed, :wagons, :route, :number, :type
  @@trains = {}

  # find train
  def self.find(train_number)
    @@trains.key?(train_number) ? @@trains[train_number] : nil
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

  def speed_up(speed)
    @speed += speed if speed.positive?
  end

  def stop
    @speed = 0
  end

  # attach wagons if speed equal to 0
  def attach(wagon)
    if @type == wagon.type && @speed.zero?
      @wagons << wagon
    elsif @speed != 0
      puts 'Denied. Train is moving'
    else
      puts 'Denied, Incorrect wagon type!'
    end
  end

  def detach
    @wagons.delete_at(-1) if @speed.zero? && @wagons.length.positive?
  end

  # set route and puts train to first station
  def add_route(route)
    @route = route
    @route.start_station.add_train(self) unless @route.start_station.trains.include?(self)
  end

  # moves to station, only one by one
  def move_forward
    @route.stations.each_with_index do |station, index|
      next unless station.trains.include?(self) && station != @route.stations.last

      station.departure(self)
      @route.stations[index + 1].add_train(self)
      print "Предыдущая: #{@route.stations[index].station_name} " unless @route.stations[index].nil?
      print "<<Текущая: #{@route.stations[index + 1].station_name}>> --> "
      print "Следующая: #{@route.stations[index + 2].station_name}\n" unless @route.stations[index + 2].nil?
      break
    end
  end

  def move_backward
    @route.stations.each_with_index do |station, index|
      next unless station.trains.include?(self) && station != @route.stations.first

      station.departure(self)
      @route.stations[index - 1].add_train(self)
      print "Следующая: #{@route.stations[index].station_name}" unless @route.stations[index].nil?
      print "<-- <<Текущая: #{@route.stations[index - 1].station_name}>> "
      print "Предыдущая: #{@route.stations[index - 2].station_name}\n" unless (index - 2).negative?
      break
    end
  end

  def each_wagon
    @wagons.each do |wagon|
      yield(wagon)
    end
  end
end

# Classes for passengers and caro
class PassengerTrain < Train
  instances

  def initialize(number, type = 'passenger')
    super
  end
end

# class for cargo train
class CargoTrain < Train
  instances

  def initialize(number, type = 'cargo')
    super
  end
end

# classes for wagons
class Wagon
  include Manufacturer

  attr_reader :id, :type

  def initialize(_size)
    @id = "W#{rand(10)}#{rand(10)}#{rand(10)}#{rand(10)}#{rand(10)}"
  end
end

# class for cargo wagon
class CargoWagon < Wagon
  attr_reader :volume, :cargo
  # DEFAUT_VOLUME = 1.0

  def initialize(size)
    super
    @volume = size
    @cargo = 0.0
    @type = 'cargo'
  end

  def fill_wagon(cargo)
    # fill the volume in range 0.0 - recieved number
    @cargo += cargo if cargo.between?(0.0, @volume)
  end

  def show_volume
    # show free volume
    @volume.-(@cargo).round(2)
  end

  def show_freight
    # show filled volume
    @cargo.round(2)
  end

  private

  attr_writer :volume, :cargo
end

# subclass for passenger types
class PassengerWagon < Wagon
  # arr for seats
  attr_accessor :seats

  def initialize(seats_number)
    super
    @type = 'passenger'
    @seats = []
    create_seats(seats_number)
  end

  # fills wagon by seats
  def create_seats(seats_number)
    seats_number.times { @seats << Seat.new }
  end

  def take_seat
    @seats.find(&free?(false))&.take
  end

  def make_room
    @seats.find(&free?(true))&.leave
  end

  # checks seats for is it taken
  def free?(boolean_value)
    ->(seat) { seat.occupancy == boolean_value }
  end

  def show_free_seats
    free_seat = ->(occupancy) { occupancy == false }
    @seats.map(&:occupancy).select(&free_seat).size
  end

  def show_taken_seats
    free_seat = ->(occupancy) { occupancy == true }
    @seats.map(&:occupancy).select(&free_seat).size
  end
end
