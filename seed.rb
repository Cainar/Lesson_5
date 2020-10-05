# frozen_string_literal: true

# Data for testing
def seed(rail_road)
  cities = %w[Moscow Arkhangelsk Voronezh Dubna Kursk Lipetsk
              Nizhny Novgorod Oryol Penza Ryazan Saint Petersburg
              Tambov Tver Tula Chelyabinsk Elista Yaroslavl Omsk]
  train_numbers = %w[T01-1C T02-1C T01-2C T01-1P T02-1P T01-2P]
  make_cities(cities, rail_road)
  make_way_stations(rail_road)

  # cargo passenger
  complete_trains(rail_road, train_numbers)

  # wagons
  complete_wagons(rail_road)
end

def make_cities(cities, rail_road)
  stations = rail_road.stations
  cities.each { |citi| rail_road.stations << Station.new(citi) }
  indexes = [[0, 5], [6, 11], [12, 17]]
  indexes.each do |index|
    rail_road.routes << Route.new(stations[index[0]], stations[index[1]])
  end
end

def make_way_stations(rail_road)
  routes = rail_road.routes
  stations = rail_road.stations
  1.upto(4) { |n| routes[0].add_station(stations[n]) }
  7.upto(10) { |n| routes[1].add_station(stations[n]) }
  13.upto(16) { |n| routes[2].add_station(stations[n]) }
end

def make_wagons(rail_road)
  cargo_volumes = (1.0...4.0).step(0.5).to_a
  cargo_volumes.each { |volume| rail_road.add_wagon(CargoWagon.new(volume)) }
  seat_volumes = (10...40).step(5).to_a
  seat_volumes.each { |volume| rail_road.add_wagon(PassengerWagon.new(volume)) }
end

def attach_wagons(rail_road)
  wagons = rail_road.wagons
  0.upto(5) { |index| rail_road.trains[0].attach(wagons[index]) }
  6.upto(11) { |index| rail_road.trains[3].attach(wagons[index]) }
end

def make_trains(rail_road, train_numbers)
  train_numbers.each_with_index do |number, index|
    rail_road.trains << if index < 3
                          CargoTrain.new(number)
                        else
                          PassengerTrain.new(number)
                        end
  end
end

def fill_space(rail_road)
  fill_counter = 0.99
  0.upto(5) do |index|
    rail_road.wagons[index].fill_wagon(fill_counter *= 1.1)
  end

  6.upto(11) do |index|
    index.times { rail_road.wagons[index].take_seat }
  end
end

def complete_wagons(rail_road)
  make_wagons(rail_road)
  attach_wagons(rail_road)
  fill_space(rail_road)
end

def complete_trains(rail_road, train_numbers)
  make_trains(rail_road, train_numbers)
  rail_road.trains.each_with_index do |train, index|
    train.add_route(rail_road.routes[index % 3])
  end
end
