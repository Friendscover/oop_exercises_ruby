#six different colors
#12 turns to decide winner
#guess order + color of the code
#colored small pin _> position and color right
#white  small pin >  position wrong color right

#compare color
#compare position
#MasterBoard is implemented like a Game class; not seperaterd in Game/Board
#storing the board?

class MasterBoard
    def initialize
        #currently no color appears twice
        @colors = ["blue", "yellow", "orange", "pink", "green", "red"]
        @current_board = @colors.sample(4)
        #needs to be removed 
        puts @current_board
    end

    def get_colors
        @colors
    end

    def get_current_board
        @current_board
    end

    def play_game
        i = 0

        while i < 12 
            p1 = Player.new
            player_choice = p1.choose_color(get_colors)
            pins = compare_color(player_choice, get_current_board)
            puts "Pins are #{pins}"
            puts 

            pins_counter = pins.count("black")
            if(pins_counter == 4)
                i = 12
            else
                i += 1
            end
        end
    end
    
    def compare_color(player_choice, pc_choice)
        pins = []
        player_choice.each_with_index do |color, index|
            #checking the players position & color
            if(color == pc_choice[index] && index == pc_choice.index(color))
                pins << "black"
            elsif(pc_choice.include?(color))
                pins << "white"
            else
                pins << "empty"
            end
        end
        pins
    end

    def compare_position(player_choice, pc_choice)
    end
end

class Player
    def choose_color(colors)
        player_choice = []
        puts "Colors that are available are #{colors}"

        4.times do |i|
            puts "Choose a color to set for place #{i + 1}!"
            choice = gets.chomp.downcase
            until colors.include?(choice)
                puts "Thats not a color, Try again!"
                choice = gets.chomp.downcase
            end
            player_choice << choice
        end

        puts "You chose #{player_choice}"
        return player_choice
    end
end

mm = MasterBoard.new
mm.play_game