class Masterboard
    def initialize
        #currently no color appears twice
        @colors = ["blue", "yellow", "orange", "pink", "green", "red"]
        @current_board = []
    end

    def get_colors
        @colors
    end

    def delete_colors(color)
        @colors.delete(color)
    end

    def get_current_board
        @current_board
    end

    def set_current_board=(colors)
        @current_board = colors
    end

    def compare_choice(guess, answer)
        pins = []
        guess.each_with_index do |color, index|
            #checking the position & color of the guess
            if(color == answer[index] && index == answer.index(color))
                pins << "black"
            elsif(answer.include?(color))
                pins << "white"
            else
                pins << "empty"
            end
        end
        pins
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

class Game
    def initialize
        play_game
    end

    def play_game
        puts "Do you wanna guess against the Computer (1) or do you wanna pick a combination and let the Computer guess (2)? Enter (1) or (2)!"
        answer = gets.chomp.to_i
        p1 = Player.new
        mb = Masterboard.new

        if(answer == 1)
            #setting the colors of the board for the player to guess
            mb.set_current_board = mb.get_colors.sample(4)
            puts mb.get_current_board

            play_turn(p1, mb)
        elsif(answer == 2)
            #player choice for the color
            mb.set_current_board = p1.choose_color(mb.get_colors)
            #computer starts guessing
            guess_turn(mb)
        else
            puts "Sorry i did not get that! Try again!"
        end       
    end

    def play_turn(player, board)
        i = 0
        while i < 12
            player_choice = player.choose_color(board.get_colors)
            pins = board.compare_choice(player_choice, board.get_current_board)
            puts "Pins are #{pins}"
            puts

            i = pins_counter(pins, i)
        end
    end

    def guess_turn(board)
        turns, i = 1, 1
        answer = []
        guess = board.get_colors.sample(4)

        while i < 12 
            puts "guess #{guess}"
            pins = board.compare_choice(guess, board.get_current_board)
            puts "pins #{pins}"
            puts ""

            pins.each_with_index do |pin, index|
                if(pin == "black")
                    answer[index] = guess[index]
                    board.delete_colors(guess[index])
                elsif(pin == "white")
                    #swapping the whitepins position 
                    pins.each_with_index do |whitepin, whiteindex|
                        if((whitepin == "white") && (whiteindex != index))
                            guess[index] = guess[whiteindex]
                        else
                            guess[index] = board.get_colors.sample
                        end
                    end
                elsif(pin == "empty")
                    board.delete_colors(guess[index])
                    guess[index] = board.get_colors.sample
                else
                    
                end
            end
            i = pins_counter(pins, i)
            turns += 1
        end

        puts "The answer is #{answer} and it took me #{turns} turns!"
    end

    def pins_counter(pins, current_iteration)
        i = current_iteration
        count_pins = pins.count("black")

        if(count_pins == 4)
            i = 12
        else
            i += 1
        end
        return i
    end
end

game = Game.new