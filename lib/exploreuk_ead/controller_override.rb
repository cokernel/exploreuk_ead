require "typhoeus"

module ExploreukEad
  module ControllerOverride
    extend ActiveSupport::Concern

    Blacklight::Configuration.default_values[:show].ead_field = 'finding_aid_url_s'
    Blacklight::Configuration.default_values[:show].partials = [:show_header, :ead, :show]
  end
end
