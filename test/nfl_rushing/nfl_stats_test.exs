defmodule NflRushing.NFLStatsTest do
  use ExUnit.Case

  alias NflRushing.NFLStats
  alias NflRushing.Repo

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "create_player" do
    test "fail to create new player when attributes are invalid" do
      assert {:error, %Ecto.Changeset{}} = NFLStats.create_player(%{})
    end

    test "create new player when attributes are valid" do
      assert {:ok, %NFLStats.Player{}} =
               NFLStats.create_player(%{
                 longest_rush: 9,
                 name: "Shaun Hill",
                 postion: "QB",
                 rushing_20_yards_each: 0,
                 rushing_40_yards_each: 0,
                 rushing_attempts: 5,
                 rushing_attempts_per_game: 1.7,
                 rushing_average_yards_per_attempt: 1.0,
                 rushing_first_downs: 0,
                 rushing_first_downs_percentage: 0.0,
                 rushing_fumbles: 0,
                 rushing_yards_per_game: 1.7,
                 team: "MIN",
                 total_rushing_touchdowns: 0,
                 total_rushing_yards: 5.0
               })
    end
  end
end
