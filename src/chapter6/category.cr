module SfmlBook::Chapter6

  module Category
    @[Flags]
    enum Type
      # "None" is added by default
      Scene
      PlayerAircraft
      AlliedAircraft
      EnemyAircraft
    end
  end
end
