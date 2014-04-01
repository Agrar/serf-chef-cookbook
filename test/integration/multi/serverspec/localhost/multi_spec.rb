require "spec_helper"
require "json"

describe "multi config serf service" do

  describe file("/etc/init/serf.conf") do
    it { should be_file }
    it { should be_owned_by "root" }
    it { should be_grouped_into "root" }
    its(:content) { should match /\/usr\/local\/bin\/serf/ }
  end

  describe service("serf") do
    it { should be_enabled }
    it { should be_running }
  end

  describe command("serf members -format=json") do
    it { should_not return_stdout /.*"make": "ford".*/ }
    it { should_not return_stdout /.*"model": "mustang".*/ }
  end


  car = {}
  car[:tags] = {}
  car[:tags][:make] = "ford"
  car[:tags][:model] = "mustang"

  File.open("/etc/serf/config.d/car.json", "w") { |f|
    f.write(JSON.pretty_generate(car.to_hash))
  }

  describe command("service serf restart") do
    it { should return_stdout /.*stop.*/ }
    it { should return_stdout /.*start\/running, process \d+.*/ }
  end

  describe service("serf") do
    it { should be_running }
  end

  describe command("serf members -format=json") do
    it { should return_stdout /.*"make": "ford".*/ }
    it { should return_stdout /.*"model": "mustang".*/ }
  end

  describe file("/var/serf/snapshot") do
     it { should be_file }
     it { should be_owned_by "serf" }
     it { should be_grouped_into "serf" }
  end

  describe file("/var/log/upstart/serf.log") do
    it { should be_file }
    it { should be_owned_by "root" }
    it { should be_grouped_into "root" }
  end

end
