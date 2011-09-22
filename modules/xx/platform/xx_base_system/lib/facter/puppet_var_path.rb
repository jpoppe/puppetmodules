directory_name = "/var/lib/puppet/var"

if !FileTest::directory?(directory_name)
  Dir::mkdir(directory_name)
end
