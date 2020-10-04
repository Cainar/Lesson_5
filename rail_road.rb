# frozen_string_literal: true

class RailRoad
  attr_reader :stations, :trains, :routes, :wagons

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end

  def add_s(station)
    @stations << station
  end

  def add_t(train)
    @trains << train
  end

  def add_r(route)
    @routes << route
  end

  def add_wagon(wagon)
    @wagons << wagon
  end

  def show_routes_list
    @routes.each_with_index do |route, index|
      puts "- #{index} - #{route.route_id} " \
           "|#{route.start_station.station_name} " \
           " - #{route.end_station.station_name}|"
    end
  end
end
