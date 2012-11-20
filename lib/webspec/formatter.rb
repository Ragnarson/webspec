require 'rspec/core/formatters/base_formatter'

class Webspec::Formatter < RSpec::Core::Formatters::BaseFormatter
  attr_reader :output_hash

  def initialize(output)
    super
    @run = Webspec.create_run
    @output_hash = {}
    @example_group = @run
  end

  def message(message)
    (@output_hash[:messages] ||= []) << message
  end

  def example_group_started(example_group)
    @example_group = @example_group.create_example_group({
      :description => example_group.description
    })
  end

  def example_group_finished(example_group)
    @example_group = @example_group.parent
  end

  def example_passed(example)
    example_finished(example)
  end

  def example_failed(example)
    example_finished(example)
  end

  def example_pending(example)
    example_finished(example)
  end

  def example_finished(example)
    @example_group.create_example(example_metadata(example))
  end

  def dump_summary(duration, example_count, failure_count, pending_count)
    super(duration, example_count, failure_count, pending_count)
    @output_hash[:summary] = {
      :duration => duration,
      :example_count => example_count,
      :failure_count => failure_count,
      :pending_count => pending_count
    }
    @output_hash[:summary_line] = summary_line(example_count, failure_count, pending_count)

    # Don't print out profiled info if there are failures, it just clutters the output
    dump_profile if profile_examples? && failure_count == 0
  end

  def summary_line(example_count, failure_count, pending_count)
    summary = pluralize(example_count, "example")
    summary << ", " << pluralize(failure_count, "failure")
    summary << ", #{pending_count} pending" if pending_count > 0
    summary
  end

  def example_metadata(example)
    {
      :description => example.description,
      :full_description => example.full_description,
      :status => example.execution_result[:status],
      :example_group => example.example_group.description,
      :execution_result => example.execution_result,
      :file_path => example.file_path,
      :line_number  => example.metadata[:line_number],
    }.tap do |hash|
      if e=example.exception
        hash[:exception] =  {
          :class => e.class.name,
          :message => e.message,
          :backtrace => e.backtrace,
        }
      end
    end
  end

  def stop
    super
  end

  def close
    @output_hash[:env] = {
      :user => ENV['USER'],
      :ruby_platform => RUBY_PLATFORM,
      :ruby_engine => RUBY_ENGINE,
      :ruby_version => RUBY_VERSION,
      :ruby_patchlevel => RUBY_PATCHLEVEL
    }

    @run.update(@output_hash)
  end
end
