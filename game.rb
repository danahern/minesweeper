require_relative 'board'
require_relative 'display'
require_relative 'location'

class Game
    STATES = [
        :configure,
        :playing,
        :game_over
    ]
    FLAG_COMMAND = "F "
    FLAG_COMMAND_POSITION = (2..-1)
    Y_POSITION_RANGE = (1..-1)
    CARDINAL_DIRECTIONS = [[1, 0], [0, -1], [0, 1], [-1, 0]]
    X = 0
    Y = 1

    attr_accessor :state, :start_time, :end_time, :board, :display

    def initialize()
        self.state = :configure
        puts "What grid size would you like?"
        grid_size = nil
        loop do
            grid_size = gets
            if invalid_grid_size?(grid_size)
                puts "Invalid value, please enter a number between 1-26"
            else
                break
            end
        end
        self.board = Board.new()
        self.board.grid_size = grid_size.to_i
        self.display = Display.new(board)
        self.board.generate()
        self.start_time = Time.now()
        self.state = :playing
        play_loop
    end 

    def invalid_grid_size?(grid_size)
        grid_size.to_i <= 1 || grid_size.to_i > 26
    end

    def is_not_on_board?(location)
        location.x_position > self.board.grid_size || location.y_position > self.board.grid_size ||
        location.x_position < 0 || location.y_position < 0
    end

    def handle_game_over
        self.end_time = Time.now()
        if self.board.bomb_found?()
            puts "Bomb selected.  Game Over."
            self.display.print_stats()
        end
        if self.board.all_bombs_flagged?()
            puts "All bombs found.  You win!"                
            self.display.print_stats()
        end
        self.state = :game_over
    end 

    def print_stats()
        uncovered_board_size = self.board.uncovered_positions.length
        board_size = self.board.grid_size**2
        print_time_played()
        puts "Made #{self.selected_positions.length} moves"
        puts "Uncovered #{uncovered_board_size} of #{board_size} (#{((uncovered_board_size.to_f/board_size)*100).round(2)})"
    end

    def print_time_played()
        play = self.end_time-self.start_time
        play_time = Time.at(play)
        puts play_time.strftime("Played for %M:%S")
    end

    def get_command
        puts "Set uncover in format 'A1'"
        puts "Set a flag position in format 'F A1'"
        puts "Enter Command: "
        command = gets
        command.upcase!
        return command
    end

    def convert_command_to_location(command)
        x_pos = command[0].ord - 'A'.ord
        y_pos = command[Y_POSITION_RANGE].to_i-1 # Subtract 1 because... computers start from 0
        return Location.new(x_pos, y_pos)
    end

    def command_is_valid?(command)
        return false if command.length > 5
        if command.include?(FLAG_COMMAND)
            position = command[FLAG_COMMAND_POSITION]
        else
            position = command
        end
        return false unless ('A'..'Z').include?(position[X])
        return false unless ('1'..'26').include?(position[Y..-1])
        return true
    end

    def uncover_location(location)
        return if self.board.is_uncovered_position?(location) || is_not_on_board?(location)
        self.board.uncovered_positions.push(location)
        if self.board.is_a_bomb?(location)
            self.state = :game_over
        end
        if self.board.number_of_bombs_nearby(location) == 0
            CARDINAL_DIRECTIONS.each do |location_modifier|
                uncover_location(Location.new(location.x_position-location_modifier[X], location.y_position-location_modifier[Y]))
            end
        end
    end

    def handle_uncover_location(command)
        location = convert_command_to_location(command)
        self.board.selected_positions.push(location)
        uncover_location(location)
    end

    def handle_command(command)
        if command.include?(FLAG_COMMAND)
            handle_flag_location(command[FLAG_COMMAND_POSITION])
        else
            handle_uncover_location(command)
        end
    end

    def handle_flag_location(command)
        location = convert_command_to_location(command)
        if is_flag_position?(location)
            self.board.flag_positions.delete_if{|loc| location == loc}
        else
            self.board.flag_positions.push(location)
            if all_bombs_flagged?()
                self.state = :game_over
            end
        end
    end

    def play_loop()
        loop do
            system("clear")
            self.display.draw_board()
            command = get_command()
            next if command_is_valid?(command)
            handle_command(command)
            break if self.state == :game_over
        end
        handle_game_over()
    end


end