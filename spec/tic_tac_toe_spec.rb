require "./tic_tac_toe/tic_tac_toe.rb"

describe "game_over" do 
  before { @board = Board.new }
  
  it "when player x has 3 right position" do
    i = 1
    while i < 4
      @board.draw_icon("x", i)
      i += 1
    end
    expect(@board.game_over?("x")).to be true
  end

  it "when player o has 3 right position" do
    i = 1
    while i < 4
      @board.draw_icon("o", i)
      i += 1
    end
    expect(@board.game_over?("o")).to be true
  end
end
