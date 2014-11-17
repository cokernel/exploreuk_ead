module ExploreukEad
  module RouteSets
    extend ActiveSupport::Concern

#    included do |klass|
#      klass.default_route_sets = [:extra_routes] + klass.default_route_sets
#    end

    protected

    def extra_routes(primary_resource)
#      add_routes do |options|
#        [
#          "details",
#          "download",
#        ].each do |action|
#          get "#{primary_resource}/:id/#{action}", to: "#{primary_resource}##{action}", as: :"#{action}_#{primary_resource}"
#        end
#      end
    end
  end
end
