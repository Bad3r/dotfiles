#!/usr/bin/ruby

if ARGV.length != 2
  raise "ARGV.length should be 2"
end

period = ARGV[0]
action = ARGV[1]

print "vmware system-sleep hook argv: #{period} #{action}\n"

VMRUN='/usr/bin/vmrun'

if not File.file?(VMRUN)
  raise "vmrun #{VMRUN} not found"
end

if period == "pre"
  vms = []
  open("|#{VMRUN} list") do |p| vms = p.readlines.map {|l| l.chomp } end
  vms.shift

  print "running vm count: #{vms.length}\n"

  vms.each do |vmxfile|
    print "Suspending #{vmxfile}\n"
    system("#{VMRUN} suspend #{vmxfile}")
    print "Suspended #{vmxfile}\n"
  end
  sleep 1
else
  print "Nothing to do\n"
end
