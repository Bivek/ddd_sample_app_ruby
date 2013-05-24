require 'ice_nine'
require 'hamster'
require 'pp'

class Itinerary
  attr_reader :legs

  # TODO Handle empty values for attributes by returning UNKNOWN location
  # TODO Add is_empty method to supporting checking for this in is_empty

  def initialize(legs)
    # TODO Check valid values

    # @legs = Hamster.list
    @legs = legs.dup

    IceNine.deep_freeze(self)
  end

  def initial_departure_location
    pp legs.first
    legs.first.load_location
  end

  def final_arrival_location
    @final_arrival_location = legs.last.unload_location
  end

  def final_arrival_date
    @final_arrival_date = legs.last.unload_date
  end

  # Checks whether provided event is expected according to this itinerary specification.
  def is_expected(handling_event)
    if (handling_event.event_type == "Load")
      return legs_contain_load_location?(handling_event.location)
    end
    false
  end

  # TODO Replace this horrible hack with correct Ruby idiom for
  # quering an array. How to search the legs for a matching location?
  # .NET: legs.Any(x => x.load_location == handling_event.location);
  def legs_contain_load_location?(handling_event_location)
    locations = Hash.new
    legs.each do |leg|
      locations[leg.load_location] = 1
    end
    return locations.has_key?(handling_event_location)
  end

  def ==(other)
    self.legs == other.legs
  end
end
