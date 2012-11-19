module Webspec
  class Example
    attr_accessor :id, :run

    def initialize(params = {})
      @id = params["_id"]
      @run = params[:run]
    end
  end
end
