$direction_array = ["N", "E", "S", "W"]

module Mission_Control

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
    if co_ordinates[0] > $x_range || co_ordinates[1] > $y_range || co_ordinates[0] < 0 || co_ordinates[1] < 0
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
      puts "Error: get_move: Order needs to be String"
    end
    puts "get_move: steps = #{steps}"
  end
end

module Drive
  def turn(order)
    case order
    when "R"
      self.co_ordinates[2] = $direction_array[($direction_array.index(co_ordinates[2])+1)%4]
    when "L"
      self.co_ordinates[2] = $direction_array[($direction_array.index(co_ordinates[2])+1)%4]
    else
      puts "Error: turn: Order needs to be either L or R"
    end
    puts "turn: co_ordinates = #{co_ordinates}"
  end

  #move by one step. this is what will be called if the order is M
  def move_by_one
    case co_ordinates[2]
    when "N"
      co_ordinates[1] += 1
    when "S"
      co_ordinates[1] -= 1
    when "E"
      co_ordinates[0] += 1
    when "W"
      co_ordinates[0] -= 1
    else
      puts "Error: move_by_one: Initial Direction cannot be read"
    end
    puts "move_by_one: co_ordinates = #{co_ordinates}"
  end

  #finally let's put everything together to drive it
  def driver
    self.get_cor
    steps = self.get_move
    steps.each do |order|
      case order
      when "L" ,"R"
        self.turn(order)
      when "M"
        self.move_by_one
        if co_ordinates[0] > $x_range || co_ordinates[1] > $y_range || co_ordinates[0] < 0 || co_ordinates[1] < 0
          break puts "Error: drive: You are Leaving Plateau"
        elsif co_ordinates[0..1] == collision_points
          break puts "Error: You are colliding with the other rover"
        end
      else
        puts "Error: drive: Command need to be either L, R, or M"
      end
    end
  end

end

#define the class Rover
class Rover
  include Mission_Control
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
eva.driver
puts "the resulting co_ordinates are #{eva.co_ordinates}"
gundam.collision_points = eva.co_ordinates[0..1]

gundam.driver
puts "the resulting co_ordinates are #{gundam.co_ordinates}"
eva.collision_points = eva.co_ordinates[0..1]
