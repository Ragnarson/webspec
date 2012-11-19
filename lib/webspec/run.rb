module Webspec
  class Run
    attr_accessor :id

    def initialize(params)
      @id = params["_id"]
    end

    def create_example_group(example_group)
      example_group = Webspec.create_example_group(example_group, self)
      example_group.parent = self
      example_group
    end

    def create_example(example)
      Webspec.create_example(example, self)
    end

    def update(params)
      Webspec.update_run(id, params)
    end
  end
end
