class Query::SpeciesListAtLocation < Query::SpeciesList
  def parameter_declarations
    super.merge(
      location: Location
    )
  end

  def initialize
    location = find_cached_parameter_instance(Location, :location)
    title_args[:location] = location.display_name
    self.where << "species_lists.location_id = '#{location.id}'"
    params[:by] ||= "name"
    super
  end
end
