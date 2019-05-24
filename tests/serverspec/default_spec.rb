require "spec_helper"
require "serverspec"

package = "freebsd_pkg_repo"
service = "freebsd_pkg_repo"
config  = "/etc/freebsd_pkg_repo/freebsd_pkg_repo.conf"
user    = "freebsd_pkg_repo"
group   = "freebsd_pkg_repo"
ports   = [PORTS]
log_dir = "/var/log/freebsd_pkg_repo"
db_dir  = "/var/lib/freebsd_pkg_repo"

case os[:family]
when "freebsd"
  config = "/usr/local/etc/freebsd_pkg_repo.conf"
  db_dir = "/var/db/freebsd_pkg_repo"
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("freebsd_pkg_repo") }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/freebsd_pkg_repo") do
    it { should be_file }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
