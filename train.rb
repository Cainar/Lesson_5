# Класс Train (Поезд):

# Возвращать предыдущую станцию, текущую, следующую, на основе маршрута

class Train

  # Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество
  # вагонов, эти данные указываются при создании экземпляра класса
  attr_reader :speed, :number_of_wagons, :route, :number, :type

  # Может возвращать количество вагонов

  def initialize(number, type, number_of_wagons)
    @number = number
    @type = type
    @number_of_wagons = number_of_wagons
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

  def attach
    @number_of_wagons += 1 if @speed == 0
  end

  def detach
    @number_of_wagons -= 1 if @speed == 0 && self.number_of_wagons > 0
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
            puts "Следующая: #{@route.stations[index + 2].station_name}" unless @route.stations[index + 2].nil?
            puts "Текущая: #{@route.stations[index + 1].station_name} <-- "
            puts "Предыдущая: #{@route.stations[index].station_name}" unless @route.stations[index].nil?
            break
          end
        end
  end

  def move_backward
        @route.stations.each_with_index do |station, index|
          if station.trains.include?(self) && station != @route.stations.first
            station.departure(self)
            @route.stations[index - 1].add_train(self)
            puts "Следующая: #{@route.stations[index - 2].station_name}" unless @route.stations[index - 2].nil?
            puts "Текущая: #{@route.stations[index - 1].station_name} <-- "
            puts "Предыдущая: #{@route.stations[index].station_name}" unless @route.stations[index].nil?
            break
          end
        end
  end



end
