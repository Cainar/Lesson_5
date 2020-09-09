  require_relative "main"

  # Тестовые данные
def seed
  s1 = Station.new('Moscow')
  s2 = Station.new('Arkhangelsk')
  s3 = Station.new('Voronezh')
  s4 = Station.new('Dubna')
  s5 = Station.new('Kursk')
  s6 = Station.new('Lipetsk')
  s7 = Station.new('Nizhny Novgorod')
  s8 = Station.new('Oryol')
  s9 = Station.new('Penza')
  s10 = Station.new('Ryazan')
  s11 = Station.new('Saint Petersburg')
  s12 = Station.new('Tambov')
  s13 = Station.new('Tver')
  s14 = Station.new('Tula')
  s15 = Station.new('Chelyabinsk')
  s16 = Station.new('Elista')
  s17 = Station.new('Yaroslavl')
  s18 = Station.new('Omsk')

  r1 = Route.new(s1, s6)
  r2 = Route.new(s7, s12)
  r3 = Route.new(s13, s18)

  r1.add_station(s2)
  r1.add_station(s3)
  r1.add_station(s4)
  r1.add_station(s5)

  r2.add_station(s8)
  r2.add_station(s9)
  r2.add_station(s10)
  r2.add_station(s11)

  r3.add_station(s14)
  r3.add_station(s15)
  r3.add_station(s16)
  r3.add_station(s17)



  # cargo passenger

  t1 = Train.new('0001', 'passenger', 5)
  t2 = Train.new('0002', 'passenger', 10)
  t3 = Train.new('0003', 'passenger', 7)
  t4 = Train.new('0004', 'cargo', 20)
  t5 = Train.new('0005', 'cargo', 15)
  t6 = Train.new('0006', 'cargo', 32)

  t1.set_route(r1)
  t2.set_route(r2)
  t3.set_route(r3)
  t4.set_route(r1)
  t5.set_route(r2)
  t6.set_route(r3)

end


