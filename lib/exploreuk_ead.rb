# ExploreukEad

module ExploreukEad
  autoload :ControllerOverride, 'exploreuk_ead/controller_override'

  require 'exploreuk_ead/version'
  require 'exploreuk_ead/engine'

  mattr_accessor :labels
  self.labels = {
    :missing => "Unknown"
  }

  
  @omit_inject = {}
  def self.omit_inject=(value)
    value = Hash.new(true) if value == true
    @omit_inject = value      
  end
  def self.omit_inject ; @omit_inject ; end

  def self.maybe_inject(options = {})
    unless omit_inject[options[:condition]]
      options[:original].send(:include, options[:override]) unless options[:original].include?(options[:override])
    end
  end

  def self.maybe_inject_helper(options = {})
    unless omit_inject[options[:condition]]
      options[:original].send(:helper, options[:override]) unless options[:original].is_a?(options[:override])
    end
  end
  
  def self.inject!
    maybe_inject original: CatalogController,
      override: ExploreukEad::ControllerOverride,
      condition: :controller_mixin

    maybe_inject_helper original: SearchHistoryController,
      override: ExploreukEadHelper,
      condition: :helper_override
  end

  # Add element to array only if it's not already there
  def self.safe_arr_add(array, element)
    array << element unless array.include?(element)
  end
  
end
