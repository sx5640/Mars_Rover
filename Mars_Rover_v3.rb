#In this version, I added a command_packager method to split the command (i.e. MMLLRMMRRRLLMMM) into block (i.e.["MM", "LLR", "MM", "RRRLL", "MMM"]). This signal will be further compressed into a shorter form (i.e. [["M", 2], ["T", -1], ["M", 2], ["T", 1], ["M", 3]]).
#The rover will take each block as one command. It will significantly reduce the number of commands that the rover will take.
#The upside of this method is that it may save memory space on the rover side. In the old way where steps was carried one by one, you have to check whether it is inside the Plateau, hit a mountain or another rover, each time the rover follow a command. That may take up some memory if there are lots of repetitive commands.
#the downside is that when the commands are not repetitive, it will actually use more resources. It will also not be able to tell exactly when did the rover left the Plateau. Neither can it tell if the rover had hit a mountain if the final co_ordinates of each move is not landed on the mountain. So let's call this version the "Aircraft Mode"


#this is a gobal variable to set directions in order, so it can be called via index
Direction_Array = ["N", "E", "S", "W"]
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
      exit
    elsif mars.check_mountains(co_ordinates) == true
      puts "Error: get_cor: You have landed on a mountain. Mission_Fail"
      exit
    elsif co_ordinates[0..1] == collision_points
      puts "Error: get_cor: You have collided with the other rover. Mission_Fail"
      exit
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

  def command_packager(steps)
    output_signal = []
    sub_steps = []
    count = 0
    temp_position = 0
    while count < steps.length
      if ["M", "L", "R"].include?(steps[count]) == false
        puts "command_packager: #{steps[count]} is not a valid command."
        exit
      elsif steps[count] != steps[count+1] && (steps[count] == "M" || steps[count+1] == "M")
        sub_steps += [steps[temp_position..count].join]
        temp_position = count+1
      end
      count += 1
    end
    puts "command_packager: sub_steps = #{sub_steps}"
    sub_steps.each do |block|
      if block.count("M") == 0
        output_signal << ["T", block.count("R") - block.count("L")]
      else
        output_signal << ["M", block.count("M")]
      end
    end
    puts "command_packager: output_signal = #{output_signal}"
    return output_signal
  end

end

#This is basically the old Drive module excluding the Mission_Control part
module Drive
  def turn(order)
    self.co_ordinates[2] = Direction_Array[(Direction_Array.index(co_ordinates[2])+order[1])%4]
    puts "turn: co_ordinates = #{co_ordinates}"
  end

  #move by one step. this is what will be called if the order is M
  def move_by_one(order)
    case co_ordinates[2]
    when "N"
      co_ordinates[1] += order[1]
    when "S"
      co_ordinates[1] -= order[1]
    when "E"
      co_ordinates[0] += order[1]
    when "W"
      co_ordinates[0] -= order[1]
    end
    puts "move_by_one: co_ordinates = #{co_ordinates}"
  end

  #finally let's put everything together to drive it
  def driver(mars)
    self.get_cor(mars)
    steps = self.get_move
    order = self.command_packager(steps)
    order.each do |block|
      case block[0]
      when "T"
        self.turn(block)
      when "M"
        self.move_by_one(block)
        #here it calls the Plateau class to tell whether the rover fall off the cliff
        if mars.check_range(co_ordinates) == true
          break puts "Error: drive: You have left the Plateau. Mission_Fail"
          exit
        elsif mars.check_mountains(co_ordinates) == true
          break puts "Error: drive: You have hit a mountain. Mission_Fail"
          exit
        elsif co_ordinates[0..1] == collision_points
          break puts "Error: drive: You have collided with the other rover. Mission_Fail"
          exit
        end
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
