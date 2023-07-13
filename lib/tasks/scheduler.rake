desc "send out push notifications"
task send_push_notifications: :environment do
  Device.send_push_notifications
  puts "push notifications sent!"
end

desc "import from vnn"
task import_vnn_schools: :environment do
  ENV["VNN_SCHOOL_IDS"].split(', ').each do |school_id|
    puts "importing #{school_id}"
    School.import_by_school_id school_id
  end
  puts "schools updated!"
end

desc "import from snap"
task import_snap_schools: :environment do
  ENV["SNAP_SCHOOL_IDS"].split(', ').each do |school_id|
    puts "importing #{school_id}"
    Snap::V1::School.find(school_id).import
  end
  puts "schools updated!"
end