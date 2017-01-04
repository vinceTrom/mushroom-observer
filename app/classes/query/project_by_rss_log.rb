module Query
  # Projects with an rss log.
  class ProjectByRssLog < Query::ProjectBase
    def initialize_flavor
      add_join(:rss_logs)
      super
    end

    def default_order
      "rss_log"
    end
  end
end
