module Query
  # Observations with an rss log.
  class ObservationByRssLog < Query::ObservationBase
    def initialize_flavor
      add_join(:rss_logs)
      super
    end

    def default_order
      "rss_log"
    end
  end
end
