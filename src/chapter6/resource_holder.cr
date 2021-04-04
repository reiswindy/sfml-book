require "crsfml"
require "./resource_identifiers"

module SfmlBook::Chapter6

  class ResourceHolder(K, V)
    getter map = {} of K => V

    def load(id : K, filename : String)
      raise "Resource already loaded for #{id}" if map[id]?
      map[id] = V.from_file(filename)
    end

    def fetch(id : K)
      raise "Resource not found for #{id}" if !map[id]?
      map[id]
    end
  end

  alias TextureHolder = ResourceHolder(Textures, SF::Texture)
  alias FontHolder    = ResourceHolder(Fonts, SF::Font)
end
