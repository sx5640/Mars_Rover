module Drive

  def get_cor
    puts "Give me my current co_ordinates"
    order = gets.chomp
    if order.class == String
      self.co_ordinates = order.split(' ')
      self.co_ordinates[0] = co_ordinates[0].to_i
      self.co_ordinates[1] = co_ordinates[1].to_i
    else
      puts "Error: get_order: co_ordinates needs to be String"
    end
    puts "get_cor: co_ordinates = #{co_ordinates}, direction = #{co_ordinates[2]} #{co_ordinates[2].class}"
  end
  #a method to input orders(Ls & Rs), and split into arrays
  def get_move
    puts "Give me Order to move"
    self.move = gets.chomp
    if move.class == String
      steps = move.upcase.split(//)
      return steps
    else
      puts "Error: get_order: Order needs to be String"
    end
    puts "get_move: steps = #{steps}"
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
    else
      puts "Error: direction_num: Cannot read direction"
    end
    puts "direction_num: co_or = #{co_or}"
    return co_or
  end

  #this method gets actual direction from its numerical form
  def num_direction(co_or)
    result_co = co_or
    if co_or[2] == 0
      result_co[2] = "N"
    elsif co_or[2] == 1
      result_co[2] = "E"
    elsif co_or[2] == 2
      result_co[2] = "S"
    elsif co_or[2] == 3
      result_co[2] = "W"
    else
      puts "Error: num_direction: Cannot read direction"
    end
    puts "num_direction result_co = #{result_co}"
    return result_co
  end

  #Let's turn it first. this is what will be called if the order is L or R
  def turn(direction, co_or)
    if direction == "R"
      if  co_or[2] == 3
        co_or[2] = 0
      else
        co_or[2] +=1
      end
    elsif direction == "L"
      if  co_or[2] == 0
        co_or[2] = 3
      else
        co_or[2] -=1
      end
    else
      puts "Error: turn: Order needs to be either L or R"
    end
    puts "turn: co_or = #{co_or}"
    return co_or
  end

  #move by one step. this is what will be called if the order is M
  def move_by_one(co_or)
    if co_or[2] == 0
      co_or[1] += 1
    elsif co_or[2] == 2
      co_or[1] -= 1
    elsif co_or[2] == 1
      co_or[0] += 1
    elsif co_or[2] == 3
      co_or[0] -= 1
    else
      puts "Error: move_by_one: Initial Direction cannot be read"
    end
    puts "move_by_one: co_or = #{co_or}"
    return co_or
  end

  #finally let's put everything together to drive it
  def driver
    self.get_cor
    steps = self.get_move
    co_or = self.direction_num
    steps.each do |direction|
      if direction == "L" || direction == "R"
        co_or = self.turn(direction, co_or)
      elsif direction == "M"
        co_or = self.move_by_one(co_or)
      else
        puts "Error: drive: Command need to be either L, R, or M"
      end
    end
    return result_co = self.num_direction(co_or)

  end

end

#define the class Rover
class Rover
  include Drive
  attr_accessor :co_ordinates, :move,
  def initialize(co_ordinate = [0, 0, "N"])
    @co_ordinates = co_ordinate
  end
end

#Create 2 Rovers
eva = Rover.new
gundam = Rover.new

#Let's Drive
puts "the resulting co_ordinates are #{eva.driver.join(" ")}"
puts "the resulting co_ordinates are #{gundam.driver.join(" ")}"
