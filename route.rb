# Класс Route (Маршрут):


# Может добавлять промежуточную станцию в список

# Может выводить список всех станций по-порядку от начальной до конечной

class Route

# --- point переименовал в station

  attr_reader :start_station, :end_station, :stations
  # Имеет начальную и конечную станцию, а также список промежуточных станций.
  # Начальная и конечная станции указываютсся при создании маршрута,

  def initialize (start_station, end_station)
    @start_station = start_station
    @end_station  = end_station
    @stations = []
    @stations << @start_station
    @stations << @end_station
  end

  # а промежуточные могут добавляться между ними.

  def add_station(station)
    @stations.shift && @stations.pop
    @stations << station
    @stations.unshift(@start_station) && @stations.push(@end_station)
  end

  # Может удалять промежуточную станцию из списка
  #--- оператор === заменил на ==

  def delete_station(station)
    @stations.delete(station) unless station == @stations.first || station == @stations.last
  end

# --- закоментировал, есть attr_reader на stations
=begin
  def show_route
    @stations.each.with_index(1) { |station, index| puts "Станция - #{index}: #{station.station_name}" }
  end
=end

end
