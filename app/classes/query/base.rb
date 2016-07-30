class Query::Base
  include Query::Initialize
  include Query::Title

  def self.parameter_declarations
    {
      join?:   [:string], # low level access
      tables?: [:string],
      where?:  [:string],
      group?:  :string,
      order?:  :string,

      by?:     :string,

      title?:  [:string],
    }
  end
end