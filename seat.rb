# frozen_string_literal: true

# сreate passenger a seat in the wagon
class Seat
  # show if seat have taken
  attr_accessor :occupancy
  # pirimary key
  attr_reader :seat_id

  def initialize
    @seat_id = "#{random_letter}#{rand(9)}#{rand(9)}"
    @occupancy = false
  end

  # take seat
  def take
    @occupancy = true
  end

  # take room
  def leave
    @occupancy = false
  end

  protected

  # create random letter
  def random_letter
    rand(10...36).to_s(36)
  end
end
