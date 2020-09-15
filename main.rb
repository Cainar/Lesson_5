

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'seed'
require_relative 'railRoad'

#def made_a_choice?(choice)
#  choices = []
#  (0..8).to_a.each { |item| choices << item.to_s}
#  choices.include?(choice)
#end

# общий класс гавного меню
class MainMenu

  attr_reader :choice, :menu_items, :menu

  require 'csv'

# road хранит все объекты в массивах
  def initialize(road)
    @@road = road
    @filename = "mainMenu.csv"
    @col = 0
  end

# получает выбор пользователя
  def make_choice
    # для очистки экрана
    #system 'clear'
    stuff
    @choice = gets.chomp.strip
  end

#запускает меню
  def start_menu
    begin
      @@menu = self
      @@menu.make_choice
      case @@menu.choice
        when "1"
          @@menu = CreateMenu.new()
          @@menu.make_choice
          @@menu.start_menu
        when "2"
          @@menu = ManipulationMenu.new()
          @@menu.make_choice
          @@menu.start_menu
        when "3"
          @@menu = InfoMenu.new()
          @@menu.make_choice
          @@menu.start_menu
        when "0"
          break
        else
          next
      end
    end while true
  end

  #Эти методы напрямую не вызываются, но могут использоваться подклассами

  protected

  # выодит текст меню из файла
  def seed_menu
    @@menu_items = (CSV.read(@filename).map { |row| row[@col] }).compact
  end

# формирует коненый вид меню и добавляет пункт для выхода
  def stuff
    seed_menu
    puts "Выберите необходимый пункт:"
    @@menu_items.each.with_index(1) { |item, index| puts "Введите #{index}, чтобы #{item}" }
    if self.class.to_s == "MainMenu"
      puts "Введите 0, чтобы выйти"
    else
      puts "Введите 0, чтобы вернуться в предыдущее меню"
    end
  end

end


# подкласс меню для создания объектов
class CreateMenu < MainMenu

  def initialize
    @filename = "mainMenu.csv"
    @col = 1
  end

  def start_menu
    begin
      case @@menu.choice

        when "1"
          print "Введите название станции: "
          @name_station = gets.chomp
          @@road.add_s(Station.new(@name_station))
          @@menu.make_choice

        when "2"
          print "Введите номер поезда: "
          @train_number = gets.chomp
          puts "Укажите тип поезда.
           - 1 - Cargo;
           - 2 - Passenger"
          @train_type = gets.chomp
          case @train_type
            when "1" then @@road.add_t(CargoTrain.new(@train_number))
            when "2" then @@road.add_t(PassengerTrain.new(@train_number))
            else next
          end
          @@menu.make_choice

        when "3"
          #@check_route_choice = []
          @@road.stations.each_with_index do |station, index|
            puts "- #{index} - #{station.station_name}"
            #@check_route_choice << index.to_s
          end
          print "Выберите начальную станцию: "
          @start_st = gets.chomp.strip.to_i
          print "Выберите конечную станцию: "
          @end_st = gets.chomp.strip.to_i
          @@road.add_r(Route.new(@@road.stations[@start_st], @@road.stations[@end_st])) if !@start_st.nil? && !@end_st.nil?

          @@menu.make_choice

        when "0"
          break
        else
          @@menu.make_choice
      end
    end while true
  end

end

# подкласс меню для изменения объектов
class ManipulationMenu < MainMenu

  def initialize()
    @filename = "mainMenu.csv"
    @col = 2
  end

  def start_menu
    begin
      case @@menu.choice

        when "1"

          @@road.trains.each_with_index do |train, index|
            puts "- #{index} - #{train.number} - #{train.type}"
          end
          print "Выберите поезд: "
          @train = gets.chomp.to_i

          @@road.routes.each_with_index do |route, index|
            puts "- #{index} - #{route.object_id} |#{route.start_station.station_name} - #{route.end_station.station_name}|"
          end
          print "Выберите маршрут: "
          @route = gets.chomp.to_i

          @@road.trains[@train].set_route(@@road.routes[@route])
          @@menu.make_choice

        when "2"
          @@road.trains.each_with_index do |train, index|
            puts "- #{index} - #{train.number} - #{train.type}"
          end
          print "Выберите поезд: "
          @train = gets.chomp.to_i
          puts "0 - чтобы отцепить вагон\n1 - чтобы прицепить вагон"
          @action = gets.chomp
          case @action
            when "0"
              @@road.trains[@train].detach
            when "1"
              @@road.wagons.each_with_index { |wagon, index| puts "- #{index} - Wagon: #{wagon.id} - type: #{wagon.type}" }
              print "Укажите индекс вагона: "
              @wagon_index = gets.chomp.to_i
              @@road.trains[@train].attach(@@road.wagons[@wagon_index])
            else next
          end
          @@menu.make_choice

        when "3"
          @@road.routes.each_with_index do |route, index|
            puts "- #{index} - #{route.object_id} |#{route.start_station.station_name} - #{route.end_station.station_name}|"
          end

          print "Выберите маршрут: "
          @route = gets.chomp.to_i

          puts "0 - чтобы удалить станцию\n1 - чтобы добавить станцию"
          @action = gets.chomp

          case @action
            when "0"
              @@road.routes[@route].stations.each_with_index do |station, index|
                puts "- #{index} - #{station.station_name}"
              end
            puts "Выберите станцию"
            @station_index = gets.chomp.to_i
            @@road.routes[@route].delete_station(@@road.routes[@route].stations[@station_index])
            when "1"
              @@road.stations.each_with_index do |station, index|
                puts "- #{index} - #{station.station_name}"
              end
            puts "Выберите станцию"
            @station_index = gets.chomp.to_i
            @@road.routes[@route].add_station(@@road.stations[@station_index])
            else next
          end
          @@menu.make_choice


        when "4"
          @@road.trains.each_with_index do |train, index|
            puts "- #{index} - #{train.number} - #{train.type}"
          end
          print "Выберите поезд: "
          @train = gets.chomp.to_i
          puts "0 - чтобы переместить поезд вперед\n1 - чтобы переместить поезд назад"
          @action = gets.chomp

          case @action
          when "0" then @@road.trains[@train].move_forward
          when "1" then @@road.trains[@train].move_backward
          else next
          end
          @@menu.make_choice

        when "0"
          break
        else
          @@menu.make_choice
      end
    end while true
  end

end

# подкласс меню для вывода информации
class InfoMenu < MainMenu

  def initialize()
    @filename = "mainMenu.csv"
    @col = 3
  end

  def start_menu
    begin
      case @@menu.choice
        when "1"

          @@road.stations.each_with_index do |station, index|
            puts "- #{index} - #{station.station_name}  #{station.show_trains_by_type}"
          end

          break

        when "0"
          break
        else
          @@menu.make_choice
      end
    end while true
  end

end


# запускает программу автоматически
def start_program (rail_road = RailRoad.new())
  # тестовый seed
  seed(rail_road)
  MainMenu.new(rail_road).start_menu
end

start_program


=begin

Задание:

    Разбить программу на отдельные классы (каждый класс в отдельном файле)
    Разделить поезда на два типа PassengerTrain и CargoTrain, сделать
      родителя для классов, который будет содержать общие методы и свойства
    Определить, какие методы могут быть помещены в private/protected и вынести
      их в такую секцию. В комментарии к методу обосновать, почему он был вынесен в private/protected
    Вагоны теперь делятся на грузовые и пассажирские (отдельные классы).
      К пассажирскому поезду можно прицепить только пассажирские, к грузовому - грузовые.
    При добавлении вагона к поезду, объект вагона должен передаваться как аргумент метода
      и сохраняться во внутреннем массиве поезда, в отличие от предыдущего задания, где
      мы считали только кол-во вагонов. Параметр конструктора "кол-во вагонов" при этом можно удалить.
=end
