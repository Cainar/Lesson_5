# frozen_string_literal: true

require_relative 'validation'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'seed'
require_relative 'rail_road'
require_relative 'accessors'

# main class for menu
class MainMenu
  include Validation
  include Accessors
  require 'csv'

  attr_reader :choice, :menu_items

  class << self
    attr_accessor :menu, :road
  end

  # road keeps data in arrays
  def initialize(road)
    self.class.road = road
    @filename = 'mainMenu.csv'
    @col = 0
  end

  # keep user choice
  def make_choice
    stuff
    @choice = user_input.strip
  end

  # start menu
  def start_menu
    loop do
      self.class.menu = self
      self.class.menu.make_choice
      case self.class.menu.choice
      when '1'
        load_menu(CreateMenu)
      when '2'
        load_menu(ManipulationMenu)
      when '3'
        load_menu(InfoMenu)
      when '0'
        break
      end
    end
  end

  # load required menu
  def load_menu(class_menu)
    self.class.menu = class_menu.new
    self.class.menu.make_choice
    self.class.menu.start_menu
  end

  protected

  # read file with menu items
  def seed_menu
    @menu_items = (CSV.read(@filename).map { |row| row[@col] }).compact
  end

  # drawing menu
  def stuff
    seed_menu
    puts 'Выберите необходимый пункт:'
    @menu_items.each.with_index(1) do |item, index|
      puts "Введите #{index}, чтобы #{item}"
    end
    if self.class.to_s == 'MainMenu'
      puts 'Введите 0, чтобы выйти'
    else
      puts 'Введите 0, чтобы вернуться в предыдущее меню'
    end
  end

  def user_input(message = '')
    print message
    gets.chomp
  end
end

# make railroad objects
class CreateMenu < MainMenu
  validate :name_station, :presence
  validate :name_station, :type, String
  validate :name_station, :format, /^[a-zA-Z]{2,16}$/i

  validate :train_number, :presence
  validate :train_number, :format, /^[a-z0-9]{3}[-]?[a-z0-9]{2}$/i

  validate :train_type, :presence
  validate :train_type, :format, /^[1-2]{1}$/

  def initialize
    @filename = 'mainMenu.csv'
    @col = 1
  end

  def start_menu
    loop do
      case self.class.superclass.menu.choice
      when '1'
        loop do
          @name_station = user_input('Введите название станции (не более 16 символов): ')
          puts self.class.superclass.validates
          if valid?(:name_station)
            self.class.superclass.road.add_s(Station.new(@name_station))
            break
          else
            puts 'СТАНЦИЯ НЕ СОЗДАНА'
          end
        end

      when '2'
        loop do
          @train_number = user_input('Введите номер поезда: ')
          if valid?(:train_number)
            loop do
              @train_type = user_input("Укажите тип поезда.\n" \
                                       "- 1 - Cargo;\n" \
                                       "- 2 - Passenger\n")
              if valid?(:train_type)
                break
              else
                puts 'необходимо ввести 1 или 2'
              end
            end
            break
          else
            puts 'ПОЕЗД НЕ СОЗДАН'
          end
        end
        case @train_type
        when '1' then self.class.superclass.road.add_t(
          CargoTrain.new(@train_number)
        )
        when '2' then self.class.superclass.road.add_t(
          PassengerTrain.new(@train_number)
        )
        else next
        end
        puts "Создан ПОЕЗД №: #{self.class.superclass.road.trains.last.number}"

      when '3'
        case user_input("Укажите тип вагона\n1 - для грузового,\n" \
                                            '2 - для пассажирского: ')
        when '1'
          self.class.superclass.road.add_wagon(
            CargoWagon.new(user_input('укажите объем: ').to_f)
          )
        when '2'
          self.class.superclass.road.add_wagon(
            PassengerWagon.new(user_input('укажите количество мест: ').to_i)
          )
        end

      when '4'
        self.class.superclass.road.stations.each_with_index do |station, index|
          puts "\t#{index}-#{station.station_name}"
        end
        @start_st = user_input('Выберите начальную станцию: ').strip.to_i
        @end_st = user_input('Выберите конечную станцию: ').strip.to_i
        if self.class.superclass.road.stations[@start_st].nil? ||
           self.class.superclass.road.stations[@end_st].nil?
          puts 'Указанной станции не существует, МАРШРУТ НЕ СОЗДАН'
        else
          self.class.superclass.road.add_r(
            Route.new(self.class.superclass.road.stations[@start_st],
                      self.class.superclass.road.stations[@end_st])
          )
          puts "создан маршрут #{self.class.superclass.road.routes.last}"
        end
      when '0'
        break
      else
        break
      end
      self.class.superclass.menu.make_choice
    end
  end
end

# change existing objects
class ManipulationMenu < MainMenu
  def initialize
    @filename = 'mainMenu.csv'
    @col = 2
  end

  def start_menu
    loop do
      case self.class.superclass.menu.choice
      when '1'
        self.class.superclass.road.trains.each_with_index do |train, index|
          puts "- #{index} - #{train.number} - #{train.type}"
        end
        @train = user_input('Выберите поезд: ').to_i
        self.class.superclass.road.show_routes_list

        @route = user_input('Выберите маршрут: ').to_i
        self.class.superclass.road.trains[@train].add_route(
          self.class.superclass.road.routes[@route]
        )

      when '2'
        trains_list(self.class.superclass.road)
        @train = user_input('Выберите поезд: ').to_i
        @action = user_input("\n0 - чтобы отцепить вагон\n" \
                               "1 - чтобы прицепить вагон\n")
        case @action
        when '0'
          self.class.superclass.road.trains[@train].detach
        when '1'
          wagons_list(self.class.superclass.road)
          @wagon_index = user_input('Укажите индекс вагона: ').to_i
          self.class.superclass.road.trains[@train].attach(
            self.class.superclass.road.wagons[@wagon_index]
          )
        else next
        end

      when '3'
        self.class.superclass.road.show_routes_list
        @route = user_input('Выберите маршрут: ').to_i
        @action = user_input("\n0 - чтобы удалить станцию\n" \
                               '1 - чтобы добавить станцию')
        case @action
        when '0'
          stations_list(self.class.superclass.road, @route)
          @station_index = user_input("\nВыберите станцию\n").to_i
          self.class.superclass.road.routes[@route].delete_station(
            self.class.superclass.road.routes[@route].stations[@station_index]
          )
        when '1'
          self.class.superclass.road.stations
              .each_with_index do |station, index|
            puts "- #{index} - #{station.station_name}"
          end
          @station_index = user_input("\nВыберите станцию\n").to_i
          self.class.superclass.road.routes[@route].add_station(
            self.class.superclass.road.stations[@station_index]
          )
        else next
        end

      when '4'
        trains_list(self.class.superclass.road)
        @train = user_input('Выберите поезд: ').to_i
        @action = user_input("0 - чтобы переместить поезд вперед\n" \
                             "1 - чтобы переместить поезд назад\n")
        case @action
        when '0' then self.class.superclass.road.trains[@train].move
        when '1' then self.class.superclass.road.trains[@train].move('back')
        else next
        end

      when '0'
        break
      else
        break
      end
      self.class.superclass.menu.make_choice
    end
  end
end

# output on screen
class InfoMenu < MainMenu
  def initialize
    @filename = 'mainMenu.csv'
    @col = 3
  end

  def start_menu
    loop do
      case self.class.superclass.menu.choice
      when '1'
        self.class.superclass.road.stations.each do |station|
          puts "Station: #{station.station_name}"
          station.each_train do |train|
            show_train_on_station(train)
            train.each_wagon do |wagon|
              show_wagons_by_type(wagon)
            end
          end
        end
      when '2'
        rendering_trains(self.class.superclass.road)
      when '3'
        rendering_wagons(self.class.superclass.road)
      when '0'
        break
      else
        break
      end
      self.class.superclass.menu.make_choice
    end
  end
end

def stations_list(road, route)
  road.routes[route].stations.each_with_index do |station, index|
    puts "- #{index} - #{station.station_name}"
  end
end

def trains_list(road)
  road.trains.each_with_index do |train, index|
    puts "- #{index} - #{train.number} - #{train.type}"
  end
end

def wagons_list(road)
  road.wagons.each_with_index do |wagon, index|
    puts "- #{index} - #{wagon.id} - #{wagon.type}"
  end
end

def rendering_trains(road)
  road.stations.each_with_index do |station, index|
    puts "\t#{index}-#{station.station_name}"
  end
  @current_station = road.stations[
    user_input('Выберите начальную станцию: ').strip.to_i
  ]
  puts "Station: #{@current_station.station_name}"
  @current_station.each_train do |train|
    show_train_on_station(train)
  end
end

def rendering_wagons(road)
  road.trains.each_with_index do |train, index|
    puts "- #{index} - #{train.number} - #{train.type}"
  end
  @current_train = road.trains[user_input('Выберите поезд: ').to_i]
  show_train_on_station(@current_train)
  @current_train.each_wagon do |wagon|
    show_wagons_by_type(wagon)
  end
end

def show_wagons_by_type(wagon)
  if wagon.type == 'cargo'
    puts "           .\\______/. wagon: #{wagon.id}-#{wagon.type}, " \
         "volume: #{wagon.show_volume}, threight: #{wagon.show_freight}"
  elsif wagon.type == 'passenger'
    puts "           .|_0__0_|. wagon: #{wagon.id}-#{wagon.type}, " \
         "free: #{wagon.show_free_seats}, " \
         "taken: #{wagon.show_taken_seats}"
  end
end

def show_train_on_station(train)
  puts "<[_-_-_]://. train: #{train.number}, type: #{train.type}, " \
                 "number of wagons: #{train.wagons.size}"
end

# keep railRoad object for cheking how it works
# $rr = nil

def start_program(rail_road = RailRoad.new)
  # test seed
  # $rr = rail_road
  seed(rail_road)
  MainMenu.new(rail_road).start_menu
end

start_program
