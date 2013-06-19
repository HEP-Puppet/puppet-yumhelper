define yumhelper::modify (
  $repository,
  $enable   = undef,
  $yum_path = "/etc/yum.repos.d") {
  if enable == true {
    exec { "sed -i 's/enabled=0/enabled=1/g' ${yum_path}/${repository}": 
    onlyif => '/usr/bin/test -f ${yum_path}/${repository}', }

    notify { "Yum repository ${repository} is now enabled": }
  } elsif enable == false {
    exec { "sed -i 's/enabled=1/enabled=0/g' ${yum_path}/${repository}.repo": 
      onlyif => '/usr/bin/test -f ${yum_path}/${repository}', }

    notify { "Yum repository ${repository} is now disabled": }
  }
}