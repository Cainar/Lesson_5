# frozen_string_literal: true

require_relative 'instance_counter'

# Class for stations
class Station
  include InstanceCounter

  attr_reader :trains, :station_name

  # class var keeps created stations
  class << self
    attr_reader :stations
  end

  def self.add_station(station)
    @stations ||= []
    @stations << station
  end

  # class method returns all stations
  def self.all
    @stations
  end

  # init register
  counter

  def initialize(station_name)
    @station_name = station_name
    @trains = []
    self.class.add_station(self)
    register_instance
  end

  # take the train by one in time
  def add_train(train)
    @trains << train
  end

  def show_trains_by_type
    @cargo = @trains.count { |train| train.type == 'cargo' }
    @passenger = @trains.count { |train| train.type == 'passenger' }
    @trains_by_type = {
      cargo: @cargo,
      passenger: @passenger
    }
  end

  def departure(train)
    @trains.delete(train)
  end

  def each_train
    @trains.each do |train|
      yield(train)
    end
  end
end
