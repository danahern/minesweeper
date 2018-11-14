class Display
    X_LABELS = ("A".."Z").to_a
    Y_LABELS = (1..26).to_a.map(&:to_s)
    EMPTY_LINE = []
    
    attr_accessor :grid_size, :board_array, :board
    
    def initialize(board)
        self.board = board
        self.grid_size = board.grid_size
    end

    def draw_board()
        self.board_array = []
        x_labels()
        board_squares()
        print_board()
    end

    def print_board()
        puts ""
        self.board_array.each do |row|
            puts " #{row.join(" | ")} |"
        end
    end

    def x_labels()
        row = ["0"]
        row += X_LABELS[0...self.grid_size]    
        self.board_array << row
    end

    def draw_single_square(location)
        if self.board.is_flag_position?(location)
            return "F"
        elsif self.board.is_uncovered_position?(location)
            if self.board.is_a_bomb?(location) # For Debugging
                return "*"
            else
                return self.board.number_of_bombs_nearby(location)
            end
        else
            return " "
        end
    end

    def board_squares()
        (0...self.grid_size).each do |y|
            row = [" #{Y_LABELS[y]}#{Y_LABELS[y].to_i < 10 ? " ": ""}"]
            (0...self.grid_size).each do |x|
                current_location = Location.new(x,y)
                row << draw_single_square(current_location)
            end
            self.board_array << row
        end
    end
end