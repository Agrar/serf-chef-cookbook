require "spec_helper"
require "json"

describe "handler" do

  describe service("serf") do
    it { should be_enabled }
    it { should be_running }
  end

  handler1 = {}
  handler1[:event_handlers] = ["/tmp/handler1.sh"]

  handler2 = {}
  handler2[:event_handlers] = ["/tmp/handler2.sh"]

  File.open("/etc/serf/config.d/handler1.json", "w") { |f|
    f.write(JSON.pretty_generate(handler1.to_hash))
  }

  File.open("/tmp/handler1.sh", "w") { |f|
    f.write("#!/bin/sh\n")
    f.write("while read line; do\n")
    f.write("echo \"$SERF_EVENT $SERF_USER_EVENT $line\" >> /tmp/handler1.sh.log\n")
    f.write("done\n")
  }

  File.chmod(0777, "/tmp/handler1.sh")

  describe command("service serf restart") do
    it { should return_stdout /.*start\/running, process \d+.*/ }
  end

  describe service("serf") do
    it { should be_running }
  end

  describe command("serf event awesome 9a020b013cab2bca7eb1b141a7d92a7d") do
    it { should return_exit_status 0 }
  end

  describe command("sleep 3") do
    it { should return_exit_status 0 }
  end

  describe file("/tmp/handler1.sh.log") do
    it { should be_file }
    its(:content) { should match /.*9a020b013cab2bca7eb1b141a7d92a7d.*/ }
  end

  File.open("/etc/serf/config.d/handler2.json", "w") { |f|
    f.write(JSON.pretty_generate(handler2.to_hash))
  }

  File.open("/tmp/handler2.sh", "w") { |f|
    f.write("#!/bin/sh\n")
    f.write("while read line; do\n")
    f.write("echo \"$SERF_EVENT $SERF_USER_EVENT $line\" >> /tmp/handler2.sh.log\n")
    f.write("done\n")
  }

  File.chmod(0777, "/tmp/handler2.sh")

  describe command("service serf restart") do
    it { should return_stdout /.*start\/running, process \d+.*/ }
  end

  describe service("serf") do
    it { should be_running }
  end

  describe command("serf event awesome 90e1640ba6fb1430a026dad0062c1851") do
    it { should return_exit_status 0 }
  end

  describe command("sleep 3") do
    it { should return_exit_status 0 }
  end

  describe file("/tmp/handler1.sh.log") do
    it { should be_file }
    its(:content) { should match /.*90e1640ba6fb1430a026dad0062c1851.*/ }
  end

  describe file("/tmp/handler2.sh.log") do
    it { should be_file }
    its(:content) { should match /.*90e1640ba6fb1430a026dad0062c1851.*/ }
  end
end
