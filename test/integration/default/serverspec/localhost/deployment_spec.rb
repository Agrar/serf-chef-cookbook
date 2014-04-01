require "spec_helper"

describe "serf service" do

  describe file("/etc/init/serf.conf") do
    it { should be_file }
    it { should be_owned_by "root" }
    it { should be_grouped_into "root" }
    its(:content) { should match /\/usr\/local\/bin\/serf/ }
  end

  it "should be running the serf service" do
    expect(service "serf").to be_enabled
    expect(service "serf").to be_running
  end

  it "should updated serf tags" do
    expect(command "serf members -format=json").to return_stdout /.*server1.*/
  end

  describe file("/var/serf/snapshot") do
     it { should be_file }
     it { should be_owned_by "serf" }
     it { should be_grouped_into "serf" }
  end

end
