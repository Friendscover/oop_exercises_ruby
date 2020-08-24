class Board
    def initialize
        @board = [1,2,3,4,5,6,7,8,9]
        @won = false
    end

    def won?
        @won
    end

    def draw_board 
        @board.each_with_index do |item, index|
            if(index == 3 || index == 6)
                print "\n #{item} |"
            else
                print  " #{item} |"
            end
        end

        puts "\n \n"
    end

    def draw_icon(icon, position)
        @board[position.to_i - 1] = icon
    end

    def play_turn(player)
        puts "#{player.name} choose a location on the board! (1-9)"
        pos = gets.chomp

        until (pos.to_i < 10 && pos.to_i > 0)
            puts "Wrong position, try again!"
            pos = gets.chomp
        end

        draw_icon(player.icon, pos)
        draw_board
        game_over?(player.icon)
    end

    def game_over?(player_icon) 
        check_player_icon_on_board = ""
        win_positions = [[1,2,3],[4,5,6],[7,8,9],[1,5,9],[1,4,7],[3,5,7],[2,5,8],[3,6,9]]

        win_positions.each do |position|
            position.each do |item|    
                if(@board[item - 1] == player_icon)
                    check_player_icon_on_board += @board[item - 1]
                end
                if(check_player_icon_on_board == (player_icon * 3))
                    @won = true
                end
            end
            check_player_icon_on_board = ""
        end
        @won
    end 
end

class Player
    def initialize(name = "Peter", icon)
        @name = name
        @icon = icon
    end

    def icon
        @icon
    end

    def name 
        @name
    end
end

def play_a_game
    b = Board.new
    b.draw_board

    puts "Player 1 choose an icon: ’x’ or ’o’"
    icon1 = gets.chomp.downcase

    #checks if the player enters a correct character for the board
    until icon1 == "x" || icon1 == "o"
        puts "Thats a wrong character. Try again!"
        icon1 = gets.chomp.downcase
    end
    p1 = Player.new("Player 1 (#{icon1})", icon1)

    icon1 == "x" ? icon2 = "o" : icon2 = "x"
    p2 = Player.new("Player 2 (#{icon2}", icon2)
    puts "Player 2 icon is #{icon2} \n"

    begin 
        b.play_turn(p1)
        b.play_turn(p2)
    end until b.won?

    puts "We got a winner!"
end

#play_a_game