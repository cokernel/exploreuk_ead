require 'rails/generators'

class ExploreukEadGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  #require File.expand_path('../assets_generator.rb', __FILE__)
  def copy_public_assets
    #ExploreukEad::AssetsGenerator.start
  end

end
