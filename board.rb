require_relative 'location'
class Board
    X = 0
    Y = 1
    attr_accessor :grid_size, :number_of_bombs, :bomb_positions, :flag_positions, :selected_positions, :uncovered_positions

    def generate
        self.bomb_positions = []
        self.number_of_bombs = bomb_config()
        1.upto(self.number_of_bombs) do |x|
            self.bomb_positions.push(generate_bomb_location())
        end
        self.flag_positions = []
        self.selected_positions = []
        self.uncovered_positions = []
    end
    
    def bomb_near_location?(bomb_position, location)
        (((bomb_position.x_position - location.x_position).abs <= 1) && 
        ((bomb_position.y_position - location.y_position).abs) <= 1)
    end

    def number_of_bombs_nearby(location)
        count = 0
        self.bomb_positions.each do |pos|
            count+=1 if bomb_near_location?(pos, location)
        end
        return count
    end

    def bomb_found?()
        self.selected_positions.any?{|pos| self.bomb_positions.any?{|p| p==pos}}
    end

    def all_bombs_flagged?()
        self.bomb_positions.all?{|pos| self.flag_positions.any?{|p| p==pos}}
    end

    def is_a_bomb?(location)
        self.bomb_positions.any?{|bomb_pos| bomb_pos == location}
    end

    def is_uncovered_position?(location)
        self.uncovered_positions.any?{|pos| pos == location}
    end

    def is_flag_position?(location)
        self.flag_positions.any?{|pos| pos == location}
    end

    def generate_bomb_location()
        x_pos = rand(self.grid_size-1)
        y_pos = rand(self.grid_size-1)
        location = Location.new(x_pos, y_pos)
        if is_a_bomb?(location) # This is already a bomb
            return generate_bomb_location()
        else
            return location
        end
    end
    

    def bomb_config
        case self.grid_size
        when 2..4
            self.grid_size - 1 # Cut down on bombs
        when 15..26
            self.grid_size + 5 # Add more bombs
        else
            self.grid_size
        end
    end

    

end