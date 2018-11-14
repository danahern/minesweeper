require "spec_helper"

RSpec.describe "MineSweeper" do
  context "Game" do
    it "should play a game" do
        expect(Minesweeper.invalid_grid_size?(200)).to be(true)
    end
  end
end