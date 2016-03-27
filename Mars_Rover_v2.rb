#In this version, I made several changes:
#1. I added a class called Plateau, which sets the boundary of the Plateau, and tells the rover whether it has passed the boundary. I also added a mountain feature, which allows you to put "mountains" inside the Plateau. The mountains are basically bad points, if the rover hit it, it will broke, just like colliding with the other rover. This feature can also be modified to allow more than 2 rovers on the ground.
#2. I divided the original Drive module into 2, one is for Mission_Control, which reads and sets co_ordinates for the rover. The other one if for driving it around.
#3. I simplified the drive method, so it no longer need to transform direction in to numerical form.


#this is a gobal variable to set directions in order, so it can be called via index
$direction_array = ["N", "E", "S", "W"]
#this is the Mission_Control module. it is still under class Rover
module Mission_Control

  #input starting co_ordinates for each rover, and transform in to arrays
  def get_cor(mars)
    puts "Give me my current co_ordinates"
    order = gets.chomp
    self.co_ordinates = order.split(' ')
    self.co_ordinates[0] = co_ordinates[0].to_i
    self.co_ordinates[1] = co_ordinates[1].to_i
    if mars.check_range(co_ordinates) == true
      puts "Error: get_cor: You have landed outside the Plateau. Mission_Fail"
    elsif mars.check_mountains(co_ordinates) == true
      puts "Error: get_cor: You have landed on a mountain. Mission_Fail"
    elsif co_ordinates[0..1] == collision_points
      puts "Error: get_cor: You have collided with the other rover. Mission_Fail"
    else
      puts "get_cor: co_ordinates = #{co_ordinates}, direction = #{co_ordinates[2]} #{co_ordinates[2].class}"
    end
  end
  #a method to input orders(Ls & Rs), and split into arrays
  def get_move
    puts "Give me Order to move"
    self.move = gets.chomp
    steps = move.upcase.split(//)
    puts "get_move: steps = #{steps}"
    return steps
  end
end

#This is basically the old Drive module excluding the Mission_Control part
module Drive
  def turn(order)
    case order
    when "R"
      self.co_ordinates[2] = $direction_array[($direction_array.index(co_ordinates[2])+1)%4]
    when "L"
      self.co_ordinates[2] = $direction_array[($direction_array.index(co_ordinates[2])-1)%4]
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
  def driver(mars)
    self.get_cor(mars)
    steps = self.get_move
    steps.each do |order|
      case order
      when "L" ,"R"
        self.turn(order)
      when "M"
        self.move_by_one
        #here it calls the Plateau class to tell whether the rover fall off the cliff
        if mars.check_range(co_ordinates) == true
          break puts "Error: drive: You have left the Plateau. Mission_Fail"
        elsif mars.check_mountains(co_ordinates) == true
          break puts "Error: drive: You have hit a mountain. Mission_Fail"
        elsif co_ordinates[0..1] == collision_points
          break puts "Error: drive: You have collided with the other rover. Mission_Fail"
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
end

#here starts the Plateau class

#this module to set the geographical properties of the Plateau
module Set_Map
  #define a function to set the size of the Plateau
  def set_range
    puts "Input the size of the Plateau"
    ranges = gets.chomp.split(" ")
    self.x_range = ranges[0].to_i
    self.y_range = ranges[1].to_i
    puts "set_range: x_range = #{x_range}, y_range = #{y_range}"
  end

  #here is a function that sets the mountains
  def set_mountains
    puts "Input the co_ordinates of mountains. Please use commma to separate each mountain's co_ordinates (i.e. 1 1, 1 2)"
    self.mountains = gets.chomp.split(", ")
    for count in (0..(mountains.count - 1)).to_a
      mountains[count] = mountains[count].split(" ")
      mountains[count][0] = mountains[count][0].to_i
      mountains[count][1] = mountains[count][1].to_i
    end
    puts "the co_ordinates of the mountains are #{mountains}"
  end
end

#this tells whether you are leaving the Plateau or hitting a mountain
module Mission_Fail
  def check_range(co_ordinates)
    if co_ordinates[0] > self.x_range || co_ordinates[1] > self.y_range || co_ordinates[0] < 0 || co_ordinates[1] < 0
      return true
    else return false
    end
  end

  def check_mountains(co_ordinates)
    return mountains.include?(co_ordinates[0..1])
  end
end

#here is the Plateau class
class Plateau
  include Set_Map
  include Mission_Fail
  attr_accessor :x_range, :y_range, :mountains

end

#Create the Plateau
mars = Plateau.new
#Create 2 Rovers
eva = Rover.new
gundam = Rover.new

#set the size of the Plateau
mars.set_range
mars.set_mountains

#Let's Drive
eva.driver(mars)
puts "the resulting co_ordinates are #{eva.co_ordinates}"
#letting the other rover know the position of the first rover
gundam.collision_points = eva.co_ordinates[0..1]

gundam.driver(mars)
puts "the resulting co_ordinates are #{gundam.co_ordinates}"
#letting the other rover know the position of the second rover
eva.collision_points = eva.co_ordinates[0..1]
