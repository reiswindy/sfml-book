module SfmlBook::Chapter5
  module Utils
    def self.center_element_origin(element : SF::Sprite | SF::Text)
      bounds = element.local_bounds
      x = bounds.left + bounds.width / 2
      y = bounds.top + bounds.height / 2
      {x.floor.to_i, y.floor.to_i}
    end
  end
end
