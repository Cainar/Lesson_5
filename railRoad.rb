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


end
