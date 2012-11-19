module Webspec
  class ExampleGroup
    attr_accessor :id, :run, :parent

    def initialize(params = {})
      @id = params["_id"]
      @run = params[:run]
    end

    def create_example_group(example_group)
      example_group = Webspec.create_example_group(example_group, run, self)
      example_group.parent = self
      example_group
    end

    def create_example(example)
      Webspec.create_example(example, run, self)
    end
  end
end
