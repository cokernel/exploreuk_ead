require 'blacklight'
require 'exploreuk_ead'
require 'rails'

module ExploreukEad
  class Engine < Rails::Engine
    Blacklight::Configuration.define_field_access :ead_header_field

    config.to_prepare do
      ExploreukEad.inject!
    end
  end
end
