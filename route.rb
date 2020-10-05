# frozen_string_literal: true

# class for Routes
class Route
  include InstanceCounter

  attr_reader :start_station, :end_station, :stations, :route_id
  # init register
  counter

  def initialize(start_station, end_station)
    @route_id = "R-#{rand(10)}#{rand(10)}"
    @start_station = start_station
    @end_station = end_station
    @stations = []
    @stations << @start_station
    @stations << @end_station
    register_instance
  end

  # add way station
  def add_station(station)
    @stations.shift && @stations.pop
    @stations << station
    @stations.unshift(@start_station) && @stations.push(@end_station)
  end

  # delete way station
  def delete_station(station)
    @stations.delete(station) unless [@stations.first, @stations.last].include?(station)
  end
end
