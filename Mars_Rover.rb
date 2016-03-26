module Drive

  #input starting co_ordinates for each rover, and transform in to arrays
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
    if co_ordinates[0] > $x_range || co_ordinates[1] > $y_range
      puts "Error: get_cor: You cannot start outside Plateau"
    elsif co_ordinates[0..1] == collision_points
      puts "Error: get_cor: You are colliding with the other rover"
    else
      puts "get_cor: co_ordinates = #{co_ordinates}, direction = #{co_ordinates[2]} #{co_ordinates[2].class}"
    end
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
    temp_co = co_ordinates
    if co_ordinates[2] == "N"
      temp_co[2] = 0
    elsif co_ordinates[2] == "E"
      temp_co[2] = 1
    elsif co_ordinates[2] == "S"
      temp_co[2] = 2
    elsif co_ordinates[2] == "W"
      temp_co[2] = 3
    else
      puts "Error: direction_num: Cannot read direction"
    end
    puts "direction_num: temp_co = #{temp_co}"
    return temp_co
  end

  #this method gets actual direction from its numerical form
  def num_direction(temp_co)
    result_co = temp_co
    if temp_co[2] == 0
      result_co[2] = "N"
    elsif temp_co[2] == 1
      result_co[2] = "E"
    elsif temp_co[2] == 2
      result_co[2] = "S"
    elsif temp_co[2] == 3
      result_co[2] = "W"
    else
      puts "Error: num_direction: Cannot read direction"
    end
    puts "num_direction result_co = #{result_co}"
    return result_co
  end

  #Let's turn it first. this is what will be called if the order is L or R
  def turn(direction, temp_co)
    if direction == "R"
      if  temp_co[2] == 3
        temp_co[2] = 0
      else
        temp_co[2] +=1
      end
    elsif direction == "L"
      if  temp_co[2] == 0
        temp_co[2] = 3
      else
        temp_co[2] -=1
      end
    else
      puts "Error: turn: Order needs to be either L or R"
    end
    puts "turn: temp_co = #{temp_co}"
    return temp_co
  end

  #move by one step. this is what will be called if the order is M
  def move_by_one(temp_co)
    if temp_co[2] == 0
      temp_co[1] += 1
    elsif temp_co[2] == 2
      temp_co[1] -= 1
    elsif temp_co[2] == 1
      temp_co[0] += 1
    elsif temp_co[2] == 3
      temp_co[0] -= 1
    else
      puts "Error: move_by_one: Initial Direction cannot be read"
    end
    puts "move_by_one: temp_co = #{temp_co}"
    return temp_co
  end

  #finally let's put everything together to drive it
  def driver
    self.get_cor
    steps = self.get_move
    temp_co = self.direction_num
    steps.each do |direction|
      if direction == "L" || direction == "R"
        temp_co = self.turn(direction, temp_co)
      elsif direction == "M"
        temp_co = self.move_by_one(temp_co)
        if temp_co[0] > $x_range || temp_co[1] > $y_range
          break puts "Error: You are Leaving Plateau"
        elsif temp_co[0..1] == collision_points
          break puts "Error: You are colliding with the other rover"
        end
      else
        puts "Error: drive: Command need to be either L, R, or M"
      end
    end
    return result_co = self.num_direction(temp_co)

  end

end

#define the class Rover
class Rover
  include Drive
  attr_accessor :co_ordinates, :move, :collision_points
  def initialize(co_ordinate = [0, 0, "N"])
    @co_ordinates = co_ordinate
  end
end

#define a function to set
def set_range
  puts "Input the size of the Plateau"
  ranges = gets.chomp.split(" ")
  if ranges.class == Array
    $x_range = ranges[0].to_i
    $y_range = ranges[1].to_i
  else
    puts "Error: set_range: ranges needs to be String"
  end
  puts "set_range: x_range = #{$x_range}, y_range = #{$y_range}"
end

#Create 2 Rovers
eva = Rover.new
gundam = Rover.new

#set the size of the Plateau
set_range

#Let's Drive
eva_final = eva.driver
puts "the resulting co_ordinates are #{eva_final.join(' ')}"
gundam.collision_points = eva_final[0..1]

gundam_final = gundam.driver
puts "the resulting co_ordinates are #{gundam_final.join(' ')}"
eva.collision_points = gundam_final[0..1]
