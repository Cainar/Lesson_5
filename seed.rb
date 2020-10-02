  require_relative "main"

  # Тестовые данные
def seed(rail_road)
  rail_road.stations << Station.new('Moscow')
  rail_road.stations << Station.new('Arkhangelsk')
  rail_road.stations << Station.new('Voronezh')
  rail_road.stations << Station.new('Dubna')
  rail_road.stations << Station.new('Kursk')
  rail_road.stations << Station.new('Lipetsk')
  rail_road.stations << Station.new('Nizhny Novgorod')
  rail_road.stations << Station.new('Oryol')
  rail_road.stations << Station.new('Penza')
  rail_road.stations << Station.new('Ryazan')
  rail_road.stations << Station.new('Saint Petersburg')
  rail_road.stations << Station.new('Tambov')
  rail_road.stations << Station.new('Tver')
  rail_road.stations << Station.new('Tula')
  rail_road.stations << Station.new('Chelyabinsk')
  rail_road.stations << Station.new('Elista')
  rail_road.stations << Station.new('Yaroslavl')
  rail_road.stations << Station.new('Omsk')

  rail_road.routes << Route.new(rail_road.stations[0],rail_road.stations[5])
  rail_road.routes << Route.new(rail_road.stations[6],rail_road.stations[11])
  rail_road.routes << Route.new(rail_road.stations[12],rail_road.stations[17])

  rail_road.routes[0].add_station(rail_road.stations[1])
  rail_road.routes[0].add_station(rail_road.stations[2])
  rail_road.routes[0].add_station(rail_road.stations[3])
  rail_road.routes[0].add_station(rail_road.stations[4])

  rail_road.routes[1].add_station(rail_road.stations[7])
  rail_road.routes[1].add_station(rail_road.stations[8])
  rail_road.routes[1].add_station(rail_road.stations[3])
  rail_road.routes[1].add_station(rail_road.stations[10])

  rail_road.routes[2].add_station(rail_road.stations[13])
  rail_road.routes[2].add_station(rail_road.stations[14])
  rail_road.routes[2].add_station(rail_road.stations[15])
  rail_road.routes[2].add_station(rail_road.stations[16])



  # cargo passenger

  rail_road.trains << CargoTrain.new('T01-1C')
  rail_road.trains << CargoTrain.new('T02-1C')
  rail_road.trains << CargoTrain.new('T01-2C')
  rail_road.trains << PassengerTrain.new('T01-1P')
  rail_road.trains << PassengerTrain.new('T02-1P')
  rail_road.trains << PassengerTrain.new('T01-2P')

  rail_road.trains[0].set_route(rail_road.routes[0])
  rail_road.trains[1].set_route(rail_road.routes[1])
  rail_road.trains[2].set_route(rail_road.routes[2])
  rail_road.trains[3].set_route(rail_road.routes[0])
  rail_road.trains[4].set_route(rail_road.routes[1])
  rail_road.trains[5].set_route(rail_road.routes[2])

  #wagons
  rail_road.add_wagon(CargoWagon.new(3.0))
  rail_road.add_wagon(PassengerWagon.new(25))
  rail_road.add_wagon(CargoWagon.new(1.5))
  rail_road.add_wagon(CargoWagon.new(1.0))
  rail_road.add_wagon(PassengerWagon.new(10))
  rail_road.add_wagon(CargoWagon.new(3.0))
  rail_road.add_wagon(PassengerWagon.new(30))
  rail_road.add_wagon(CargoWagon.new(3.0))
  rail_road.add_wagon(PassengerWagon.new(30))
  rail_road.add_wagon(PassengerWagon.new(25))
  rail_road.add_wagon(PassengerWagon.new(10))
  rail_road.add_wagon(CargoWagon.new(2.5))

  rail_road.trains[0].attach(rail_road.wagons[0])
  rail_road.trains[3].attach(rail_road.wagons[1])
  rail_road.trains[0].attach(rail_road.wagons[2])
  rail_road.trains[0].attach(rail_road.wagons[3])
  rail_road.trains[3].attach(rail_road.wagons[4])
  rail_road.trains[0].attach(rail_road.wagons[5])
  rail_road.trains[3].attach(rail_road.wagons[6])
  rail_road.trains[1].attach(rail_road.wagons[7])
  rail_road.trains[3].attach(rail_road.wagons[8])
  rail_road.trains[4].attach(rail_road.wagons[9])
  rail_road.trains[4].attach(rail_road.wagons[10])
  rail_road.trains[1].attach(rail_road.wagons[11])

  rail_road.wagons[0].fill_wagon(0.1)
  rail_road.wagons[1].take_seat
  rail_road.wagons[1].take_seat
  rail_road.wagons[2].fill_wagon(0.2)
  rail_road.wagons[3].fill_wagon(0.3)
  rail_road.wagons[4].take_seat
  rail_road.wagons[4].take_seat
  rail_road.wagons[4].take_seat
  rail_road.wagons[5].fill_wagon(0.4)
  rail_road.wagons[6].take_seat
  rail_road.wagons[7].fill_wagon(0.56)
  rail_road.wagons[8].take_seat
  rail_road.wagons[8].take_seat
  rail_road.wagons[8].take_seat
  rail_road.wagons[8].take_seat
  rail_road.wagons[8].take_seat
  rail_road.wagons[8].take_seat
  rail_road.wagons[8].take_seat
  rail_road.wagons[9].take_seat
  rail_road.wagons[10].take_seat
  rail_road.wagons[11].fill_wagon(0.49)

end


