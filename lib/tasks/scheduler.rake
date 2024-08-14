desc "send out push notifications"
task send_push_notifications: :environment do
  slug = "push-notifications"
  check_in_id = Sentry.capture_check_in(slug, :in_progress)

  begin
    Device.send_push_notifications
    puts "push notifications sent!"
    Sentry.capture_check_in(slug, :ok, check_in_id: check_in_id)
  rescue StandardError
    Sentry.capture_check_in(slug, :error, check_in_id: check_in_id)
  end
end

desc "import from vnn"
task import_vnn_schools: :environment do
  slug = "import-vnn-schools"
  check_in_id = Sentry.capture_check_in(slug, :in_progress)

  begin
    ENV["VNN_SCHOOL_IDS"].split(", ").each do |school_id|
      puts "importing #{school_id}"
      School.import_by_school_id school_id
    end
    puts "schools updated!"
    Sentry.capture_check_in(slug, :ok, check_in_id: check_in_id)
  rescue StandardError
    Sentry.capture_check_in(slug, :error, check_in_id: check_in_id)
  end
end

desc "import from snap"
task import_snap_schools: :environment do
  slug = "import-snap-schools"
  check_in_id = Sentry.capture_check_in(slug, :in_progress)

  begin
    ENV["SNAP_SCHOOL_IDS"].split(", ").each do |school_id|
      puts "importing #{school_id}"
      Snap::V2::Client.import(school_id)
    end
    puts "schools updated!"
    Sentry.capture_check_in(slug, :ok, check_in_id: check_in_id)
  rescue StandardError
    Sentry.capture_check_in(slug, :error, check_in_id: check_in_id)
  end
end
