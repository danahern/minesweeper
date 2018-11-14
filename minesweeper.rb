require 'byebug'
require_relative 'game'
require_relative 'board'


# Board
# 0 | A | B | C |
# 1 |   |   |   |
# 2 |   |   |   |
# 3 |   |   |   |

# @x_labels = ("A".."Z").to_a
# @y_labels = (1..26).to_a.map(&:to_s)
# X = 0 # In location object position of X
# Y = 1 # In location object position of Y

# FLAG_COMMAND = "F "
# FLAG_COMMAND_POSITION = (2..-1)
# Y_POSITION_RANGE = (1..-1)
# CARDINAL_DIRECTIONS = [[1, 0], [0, -1], [0, 1], [-1, 0]]

# @global_config = {
#     grid_size: 0,
#     bombs: 0,
#     bomb_positions: [],
#     flag_positions: [],
#     selected_positions: [],
#     uncovered_positions: [],
#     game_over: false,
#     start_time: nil,
#     end_time: nil
# }

# def invalid_grid_size?(grid_size)
#     grid_size.to_i <= 1 || grid_size.to_i > 26
# end

# def bomb_config
#     case @global_config[:grid_size]
#     when 2..4
#         @global_config[:grid_size] - 1 # Cut down on bombs
#     when 15..26
#         @global_config[:grid_size] + 5 # Add more bombs
#     else
#         @global_config[:grid_size]
#     end
# end

# def configure
#     puts "What grid size would you like?"
#     grid_size = gets
#     if invalid_grid_size?(grid_size)
#         puts "Invalid value, please enter a number between 1-26"
#         configure()
#     end
    
#     @global_config[:grid_size] = grid_size.to_i
#     @global_config[:bombs] = bomb_config()
#     @global_config[:start_time] = Time.now()
# end

# def is_not_on_board?(location)
#     location[X] > @global_config[:grid_size] || location[Y] > @global_config[:grid_size] ||
#     location[X] < 0 || location[Y] < 0
# end

# def is_a_bomb?(location)
#     @global_config[:bomb_positions].any?{|bomb_pos| bomb_pos == location}
# end

# For debug
# def is_already_uncovered?(location)
#     @global_config[:uncovered_positions].any?{|pos| pos == location}
# end

# def is_uncovered_position?(location)
#     @global_config[:uncovered_positions].any?{|pos| pos == location}
# end

# def is_flag_position?(location)
#     @global_config[:flag_positions].any?{|pos| pos == location}
# end

# def bomb_near_location?(bomb_position, location)
#     (((bomb_position[X] - location[X]).abs <= 1) && 
#     ((bomb_position[Y] - location[Y]).abs) <= 1)
# end

# def generate_bomb_location()
#     x_pos = rand(@global_config[:grid_size]-1)
#     y_pos = rand(@global_config[:grid_size]-1)
#     location = [x_pos, y_pos]
#     if is_a_bomb?(location) # This is already a bomb
#         return generate_bomb_location()
#     else
#         return location
#     end
# end

# def generate_board()
#     1.upto(@global_config[:bombs]) do |x|
#         @global_config[:bomb_positions].push(generate_bomb_location())
#     end
# end

# def draw_x_labels()
#     "\n O  | " << @x_labels[0...(@global_config[:grid_size])].join(" | ") << " |\n"    
# end

# def number_of_bombs_nearby(location)
#     count = 0
#     @global_config[:bomb_positions].each do |pos|
#         count+=1 if bomb_near_location?(pos, location)
#     end
#     return count
# end

# def draw_single_square(location)
#     if is_flag_position?(location)
#         return "F"
#     elsif is_uncovered_position?(location)
#         if is_a_bomb?(location) # For Debugging
#             return "*"
#         else
#             return number_of_bombs_nearby(location)
#         end
#     else
#         return " "
#     end
# end

# def draw_board_squares()
#     rows = ""
#     (0...@global_config[:grid_size]).each do |y|
#         rows << " #{@y_labels[y]}#{@y_labels[y].to_i < 10 ? " ": ""} |"
#         (0...@global_config[:grid_size]).each do |x|
#             rows << " #{draw_single_square([x,y])} |"
#         end
#         rows << "\n"
#     end
#     return rows
# end

# def draw_board()
#     board = ""
#     board << draw_x_labels()
#     board << draw_board_squares()
#     puts board
# end

# def get_command
#     puts "Set uncover in format 'A1'"
#     puts "Set a flag position in format 'F A1'"
#     puts "Enter Command: "
#     command = gets
#     command.upcase!
#     return command
# end

# def command_is_valid?(command)
#     return false if command.length > 5
#     if command.include?(FLAG_COMMAND)
#         position = command[FLAG_COMMAND_POSITION]
#     else
#         position = command
#     end
#     return false unless ('A'..'Z').include?(position[X])
#     return false unless ('1'..'26').include?(position[Y..-1])
#     return true
# end

# def convert_command_to_location(command)
#     x_pos = command[0].ord - 'A'.ord
#     y_pos = command[Y_POSITION_RANGE].to_i-1 # Subtract 1 because... computers start from 0
#     return [x_pos, y_pos]
# end

# def handle_flag_location(command)
#     location = convert_command_to_location(command)
#     if is_flag_position?(location)
#         @global_config[:flag_positions].delete_if{|loc| location == loc}
#     else
#         @global_config[:flag_positions].push(location)
#         if all_bombs_flagged?()
#             @global_config[:game_over] = true
#         end
#     end
# end

# def uncover_location(location)
#     return if is_uncovered_position?(location) || is_not_on_board?(location)
#     @global_config[:uncovered_positions].push(location)
#     if is_a_bomb?(location)
#         @global_config[:game_over] = true
#     end
#     if number_of_bombs_nearby(location) == 0
#         CARDINAL_DIRECTIONS.each do |location_modifier|
#             uncover_location([location[X]-location_modifier[X], location[Y]-location_modifier[Y]])
#         end
#     end
# end

# def handle_uncover_location(command)
#     location = convert_command_to_location(command)
#     @global_config[:selected_positions].push(location)
#     uncover_location(location)
# end

# def handle_command(command)
#     if command.include?(FLAG_COMMAND)
#         handle_flag_location(command[FLAG_COMMAND_POSITION])
#     else
#         handle_uncover_location(command)
#     end
# end

# def bomb_found?()
#     @global_config[:selected_positions].any?{|pos| @global_config[:bomb_positions].any?{|p| p==pos}}
# end

# def all_bombs_flagged?()
#     @global_config[:bomb_positions].all?{|pos| @global_config[:flag_positions].any?{|p| p==pos}}
# end

# def print_time_played()
#     play = @global_config[:end_time]-@global_config[:start_time]
#     play_time = Time.at(play)
#     puts play_time.strftime("Played for %M:%S")
# end



# Main app
def main
    game = Game.new()
end

main()