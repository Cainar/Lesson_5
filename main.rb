

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'seed'

#def made_a_choice?(choice)
#  choices = []
#  (0..8).to_a.each { |item| choices << item.to_s}
#  choices.include?(choice)
#end

class MainMenu

  attr_reader :choice, :menu_items

  require 'csv'

  def initialize
    @filename = "mainMenu.csv"
    @col = 0
  end

  def make_choice
    system 'clear'
    stuff
    @choice = gets.chomp.strip
  end

  def start_menu
    begin
      @menu = MainMenu.new()
      @menu.make_choice
      case @main.choice
        when "1"
          @menu = CreateMenu.new()
          @menu.make_choice
        when "2"
          @menu = ManipulationMenu.new()
          manipulation_menu.make_choice
        when "3"
          info_menu = InfoMenu.new()
          info_menu.make_choice
        when "0"
          break
        else
          next
      end
    end while true
  end

  private

  def seed_menu
    @menu_items = (CSV.read(@filename).map { |row| row[@col] }).compact
  end

  def stuff
    seed_menu
    puts "Выберите необходимый пункт:"
    @menu_items.each.with_index(1) { |item, index| puts "Введите #{index}, чтобы #{item}" }
    if self.class.to_s == "MainMenu"
      puts "Введите 0, чтобы выйти"
    else
      puts "Введите 0, чтобы вернуться в предыдущее меню"
    end
  end

end


class CreateMenu < MainMenu

  def initialize
    super
    @col = 1
  end

  def make_choice
    super
    puts self.choice
  end
#  def method_1
#    begin
#      case self.choice
#        when "1"
#          puts "create_station"
#        when "2"
#          puts "create_train"
#        when "3"
#          puts "create_route"
#        when "0"
#          # break
#        else
#          # next
#      end
#    end
#  end while true

end

class ManipulationMenu < MainMenu

  def initialize
    super
    @col = 2
  end

end

class InfoMenu < MainMenu

  def initialize
    super
    @col = 3
  end

end

def start_program
  (MainMenu.new()).start_menu
end


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
