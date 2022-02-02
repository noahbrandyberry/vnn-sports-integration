desc "send out push notifications"
task send_push_notifications: :environment do
  Device.send_push_notifications
  puts "push notifications sent!"
end

desc "update schools"
task update_schools: :environment do
  ENV["SCHOOL_IDS"].split(', ').each do |school_id|
    puts "importing #{school_id}"
    School.import_by_school_id school_id
  end
  puts "schools updated!"
end