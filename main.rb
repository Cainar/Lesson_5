# frozen_string_literal: true

require_relative 'validation'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'seed'
require_relative 'rail_road'

# main class for menu
class MainMenu
  include Validation
  require 'csv'

  attr_reader :choice, :menu_items, :menu

  # road keeps data in arrays
  def initialize(road)
    @@road = road
    @filename = 'mainMenu.csv'
    @col = 0
  end

  # keep user choice
  def make_choice
    stuff
    @choice = gets.chomp.strip
  end

  # start menu
  def start_menu
    loop do
      @@menu = self
      @@menu.make_choice
      case @@menu.choice
      when '1'
        load_menu(CreateMenu)
      when '2'
        load_menu(ManipulationMenu)
      when '3'
        load_menu(InfoMenu)
      when '0'
        break
      end
      break unless true
    end
  end

  # load required menu
  def load_menu(class_menu)
    puts
    @@menu = class_menu.new
    @@menu.make_choice
    @@menu.start_menu
  end

  protected

  # read file with menu items
  def seed_menu
    @@menu_items = (CSV.read(@filename).map { |row| row[@col] }).compact
  end

  # drawing menu
  def stuff
    seed_menu
    puts 'Выберите необходимый пункт:'
    @@menu_items.each.with_index(1) do |item, index|
      puts "Введите #{index}, чтобы #{item}"
    end
    if self.class.to_s == 'MainMenu'
      puts 'Введите 0, чтобы выйти'
    else
      puts 'Введите 0, чтобы вернуться в предыдущее меню'
    end
  end
end

class CreateMenu < MainMenu
  def initialize
    @filename = 'mainMenu.csv'
    @col = 1
  end

  def start_menu
    loop do
      case @@menu.choice
      when '1'
        loop do
          print 'Введите название станции: '
          @name_station = gets.chomp
          if valid?(@name_station, 'more', 16)
            @@road.add_s(Station.new(@name_station))
            break
          else
            p 'СТАНЦИЯ НЕ СОЗДАНА'
            p err_title('length', 'more', 16)
            p err_title('nil')
          end
        end
        @@menu.make_choice

      when '2'
        loop do
          print 'Введите номер поезда: '
          @train_number = gets.chomp
          if valid?(@train_number,
                    'less',
                    @train_number.include?('-') ? 6 : 5,
                    /^[a-z0-9]{3}[-]?[a-z0-9]{2}$/i)
            loop do
              puts "Укажите тип поезда.
                      - 1 - Cargo;
                      - 2 - Passenger"
              @train_type = gets.chomp
              if valid?(@train_type,
                        'more',
                        1,
                        /^[1-2]{1}$/)
                break
              else
                p err_title('length', 'more', 1)
                p err_title('nil')
                p err_title('format', nil, nil, '/^[1-2]{1}$/')
                p 'необходимо ввести 1 или 2'
              end
            end

            break
          else
            p err_title('length', 'more', 5)
            p err_title('nil')
            p err_title('format', nil, nil, '/^[a-z0-9]{3}[-]?[a-z0-9]{2}$/i')
            p 'ПОЕЗД НЕ СОЗДАН'
          end
        end
        case @train_type
        when '1' then @@road.add_t(CargoTrain.new(@train_number))
        when '2' then @@road.add_t(PassengerTrain.new(@train_number))
        else next
        end
        puts "Создан ПОЕЗД №: #{@@road.trains.last.number}"
        @@menu.make_choice

      when '3'
        print 'Укажите тип поезда (1-для грузового, 2-для пассажирского): '

        case gets.chomp
        when '1'
          print 'укажите объем: '
          @@road.add_wagon(CargoWagon.new(gets.chomp.to_f))
        when '2'
          print 'укажите количество мест: '
          @@road.add_wagon(PassengerWagon.new(gets.chomp.to_i))
        end
        @@menu.make_choice

      when '4'
        @@road.stations.each_with_index do |station, index|
          puts "\t#{index}-#{station.station_name}"
        end
        print 'Выберите начальную станцию: '
        @start_st = gets.chomp.strip.to_i
        print 'Выберите конечную станцию: '
        @end_st = gets.chomp.strip.to_i
        if @@road.stations[@start_st].nil? || @@road.stations[@end_st].nil?
          puts 'Указанной станции не существует, МАРШРУТ НЕ СОЗДАН'
        else
          @@road.add_r(Route.new(
                         @@road.stations[@start_st],
                         @@road.stations[@end_st]
                       ))
          puts "создан маршрут #{@@road.routes.last}"
        end
        @@menu.make_choice

      when '0'
        break
      else
        @@menu.make_choice
      end
      break unless true
    end
  end
end

class ManipulationMenu < MainMenu
  def initialize
    @filename = 'mainMenu.csv'
    @col = 2
  end

  def start_menu
    loop do
      case @@menu.choice

      when '1'

        @@road.trains.each_with_index do |train, index|
          puts "- #{index} - #{train.number} - #{train.type}"
        end
        print 'Выберите поезд: '
        @train = gets.chomp.to_i

        @@road.show_routes_list
        print 'Выберите маршрут: '
        @route = gets.chomp.to_i

        @@road.trains[@train].add_route(@@road.routes[@route])
        @@menu.make_choice

      when '2'
        @@road.trains.each_with_index do |train, index|
          puts "- #{index} - #{train.number} - #{train.type}"
        end
        print 'Выберите поезд: '
        @train = gets.chomp.to_i
        puts "0 - чтобы отцепить вагон\n1 - чтобы прицепить вагон"
        @action = gets.chomp
        case @action
        when '0'
          @@road.trains[@train].detach
        when '1'
          @@road.wagons.each_with_index do |wagon, index|
            puts "- #{index} - Wagon: #{wagon.id} - type: #{wagon.type}"
          end
          print 'Укажите индекс вагона: '
          @wagon_index = gets.chomp.to_i
          @@road.trains[@train].attach(@@road.wagons[@wagon_index])
        else next
        end
        @@menu.make_choice

      when '3'
        @@road.show_routes_list
        print 'Выберите маршрут: '
        @route = gets.chomp.to_i

        puts "0 - чтобы удалить станцию\n1 - чтобы добавить станцию"
        @action = gets.chomp

        case @action
        when '0'
          @@road.routes[@route].stations.each_with_index do |station, index|
            puts "- #{index} - #{station.station_name}"
          end
          puts 'Выберите станцию'
          @station_index = gets.chomp.to_i
          @@road.routes[@route].delete_station(@@road.routes[@route]
            .stations[@station_index])
        when '1'
          @@road.stations.each_with_index do |station, index|
            puts "- #{index} - #{station.station_name}"
          end
          puts 'Выберите станцию'
          @station_index = gets.chomp.to_i
          @@road.routes[@route].add_station(@@road.stations[@station_index])
        else next
        end
        @@menu.make_choice

      when '4'
        @@road.trains.each_with_index do |train, index|
          puts "- #{index} - #{train.number} - #{train.type}"
        end
        print 'Выберите поезд: '
        @train = gets.chomp.to_i
        puts "0 - чтобы переместить поезд вперед\n" \
             '1 - чтобы переместить поезд назад'
        @action = gets.chomp

        case @action
        when '0' then @@road.trains[@train].move_forward
        when '1' then @@road.trains[@train].move_backward
        else next
        end
        @@menu.make_choice

      when '0'
        break
      else
        @@menu.make_choice
      end
    end
  end
end

class InfoMenu < MainMenu
  def initialize
    @filename = 'mainMenu.csv'
    @col = 3
  end

  def start_menu
    loop do
      case @@menu.choice
      when '1'
        @@road.stations.each do |station|
          puts "Station: #{station.station_name}"
          station.each_train do |train|
            puts "<[_-_-_]://. train: #{train.number}, type: #{train.type}, " \
                 "number of wagons: #{train.wagons.size}"
            train.each_wagon do |wagon|
              if wagon.type == 'cargo'
                puts "           .\\_____/. wagon: #{wagon.id}-#{wagon.type}," \
                     " volume: #{wagon.show_volume}, " \
                     "threight: #{wagon.show_freight}"
              elsif wagon.type == 'passenger'
                puts "           .|_0__0_|. wagon: #{wagon.id}-#{wagon.type}," \
                     " free: #{wagon.show_free_seats}, " \
                     "taken: #{wagon.show_taken_seats}"
              end
            end
          end
        end
        @@menu.make_choice

      when '2'
        @@road.stations.each_with_index do |station, index|
          puts "\t#{index}-#{station.station_name}"
        end
        print 'Выберите начальную станцию: '
        @current_station = @@road.stations[gets.chomp.strip.to_i]
        puts "Station: #{@current_station.station_name}"
        @current_station.each_train do |train|
          puts "<[_-_-_]://. train: #{train.number}, type: #{train.type}, " \
               " number of wagons: #{train.wagons.size}"
        end
        @@menu.make_choice

      when '3'
        @@road.trains.each_with_index do |train, index|
          puts "- #{index} - #{train.number} - #{train.type}"
        end
        print 'Выберите поезд: '
        @current_train = @@road.trains[gets.chomp.to_i]
        puts "<[_-_-_]://. train: #{@current_train.number}, " \
             "type: #{@current_train.type}, " \
             "number of wagons: #{@current_train.wagons.size}"
        @current_train.each_wagon do |wagon|
          if wagon.type == 'cargo'
            puts "           .\\______/. wagon: #{wagon.id}-#{wagon.type}, " \
                 "volume: #{wagon.show_volume}, threight: #{wagon.show_freight}"
          elsif wagon.type == 'passenger'
            puts "           .|_0__0_|. wagon: #{wagon.id}-#{wagon.type}, " \
                 "free: #{wagon.show_free_seats}, " \
                 "taken: #{wagon.show_taken_seats}"
          end
        end
        @@menu.make_choice

      when '0'
        break
      else
        @@menu.make_choice
      end
      break unless true
    end
  end
end

# keep railRoad object for cheking how it works
$rr = nil

def start_program(rail_road = RailRoad.new)
  # тестовый seed
  $rr = rail_road
  seed($rr)
  MainMenu.new($rr).start_menu
end

start_program
