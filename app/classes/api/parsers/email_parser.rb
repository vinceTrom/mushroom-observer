class API
  module Parsers
    # Parse email addresses for API.
    class EmailParser < StringParser
      EMAIL = /^[\w\-]+@[\w\-]+(\.[\w\-]+)+$/.freeze

      def parse(str)
        val = super || return
        return val if EMAIL.match?(val)

        raise BadParameterValue.new(val, :email)
      end
    end
  end
end
