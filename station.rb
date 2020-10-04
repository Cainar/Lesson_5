# frozen_string_literal: true

require_relative 'instance_counter'

# Class for stations
class Station
  include InstanceCounter

  attr_reader :trains, :station_name

  # class var keeps created stations
  @@stations = []

  # class method returns all stations
  def self.all
    @@stations
  end

  # init register
  instances

  def initialize(station_name)
    @station_name = station_name
    @trains = []
    @@stations << self
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
