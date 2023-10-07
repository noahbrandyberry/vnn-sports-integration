desc "send out push notifications"
task send_push_notifications: :environment do
  cron = Sentry::Cron.new "https://o4505516763250688.ingest.sentry.io/api/4505522776506368/cron/push-notifications/7d7abd20cb1b429d9dcec3931830fbb9/"
  cron.start

  begin
    Device.send_push_notifications
    puts "push notifications sent!"
    cron.complete
  rescue =>
    cron.error
  end
end

desc "import from vnn"
task import_vnn_schools: :environment do
  cron = Sentry::Cron.new "https://o4505516763250688.ingest.sentry.io/api/4505522776506368/cron/import-vnn-schools/7d7abd20cb1b429d9dcec3931830fbb9/"
  cron.start

  begin
    ENV["VNN_SCHOOL_IDS"].split(', ').each do |school_id|
      puts "importing #{school_id}"
      School.import_by_school_id school_id
    end
    puts "schools updated!"
    cron.complete
  rescue =>
    cron.error
  end
end

desc "import from snap"
task import_snap_schools: :environment do
  cron = Sentry::Cron.new "https://o4505516763250688.ingest.sentry.io/api/4505522776506368/cron/import-snap-schools/7d7abd20cb1b429d9dcec3931830fbb9/"
  cron.start

  begin
    ENV["SNAP_SCHOOL_IDS"].split(', ').each do |school_id|
      puts "importing #{school_id}"
      Snap::V1::School.find(school_id).import
    end
    puts "schools updated!"
    cron.complete
  rescue =>
    cron.error
  end
end