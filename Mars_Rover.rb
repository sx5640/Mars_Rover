module Drive
  #a method to input orders(Ls & Rs), and split into arrays
  def get_order
    puts "Give me Order"
    order = gets.chomp
    if order.class == Class
      steps = order.upcase.split(//)
    else
      puts "Error: get_order: Order needs to be String"
    end
  end

  #creating a method that take NESW direciton and outputs in numerical form, in order to simplify the change
  def direction_num
    co_or = co_ordinates
    if co_ordinates[2] == "N"
      co_or[2] = 0
    elsif co_ordinates[2] == "E"
      co_or[2] = 1
    elsif co_ordinates[2] == "S"
      co_or[2] = 2
    elsif co_ordinates[2] == "W"
      co_or[2] = 3
    end
    return co_or
  end

  #this method gets actual direction from its numerical form
  def num_direction
    result_co = co_or
    if co_or[2] == 0
      result_co[2] = "N"
    elsif co_or[2] == 1
      result_co[2] = "E"
    elsif co_or[2] == 2
      result_co[2] = "S"
    elsif co_or[2] == 3
      result_co[2] = "W"
    end
    return result_co
  end

  #Let's turn it first. this is what will be called if the order is L or R
  def turn(direction)
    if direction == "R"
      if  co_co[2] == 3
        co_co[2] = 0
      else
        co_co[2] +=1
      end
    elsif direction == "L"
      if  co_co[2] == 0
        co_co[2] = 3
      else
        co_co[2] -=1
      end
    else
      puts "Error: turn: Order needs to be either L or R"
    end
    return result_co
  end

  #move by one step. this is what will be called if the order is M
  def move_by_one
    if co_or[2] == "N"
      co_or[1] += 1
    elsif co_or[2] == "S"
      co_or[1] -= 1
    elsif co_or[2] == "E"
      co_or[0] += 1
    elsif co_or[2] == "W"
      co_or[0] -= 1
    else
      puts "Error: move: Initial Direction cannot be read"
    end
    return co_or
  end

end

class Rover
  include Drive
  attr_accessor :co_ordinates
  def initialize(co_ordinate = [0, 0, "N"])
    @co_ordinates = co_ordinate
  end
end