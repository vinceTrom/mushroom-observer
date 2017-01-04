module Query
  # Images with observations created by a given user.
  class ImageWithObservationsByUser < Query::ImageBase
    include Query::Initializers::ObservationFilters

    def parameter_declarations
      super.merge(
        user:    User,
        old_by?: :string
      ).merge(observation_filter_parameter_declarations)
    end

    def initialize_flavor
      user = find_cached_parameter_instance(User, :user)
      title_args[:user] = user.legal_name
      add_join(:images_observations, :observations)
      where << "observations.user_id = '#{user.id}'"
      initialize_observation_filters
      super
    end

    def default_order
      "name"
    end

    def coerce_into_observation_query
      Query.lookup(:Observation, :by_user, params_with_old_by_restored)
    end
  end
end
