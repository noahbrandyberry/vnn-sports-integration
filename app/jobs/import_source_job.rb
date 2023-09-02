class ImportSourceJob < ApplicationJob
  queue_as :urgent

  after_enqueue do |job|
    import_source = job.arguments.first
    import_source.update(last_import_time: nil)
    import_source.events.destroy_all
  end

  def perform(import_source)
    import_source.sync
  end
end
