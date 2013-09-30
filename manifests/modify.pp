define yumhelper::modify (
  $repository,
  $enable                 = undef,
  $yum_path               = '/etc/yum.repos.d',
  $use_yum_config_manager = true,) {
  if $use_yum_config_manager == true {
    if $enable {
      $change = '--enable'
    } else {
      $change = '--disable'
    }

    exec { "yum-config-manager $change $repository":
      onlyif => "test `yum repolist all | grep $repository | wc -l` -gt 0",
      path   => [
        '/sbin',
        '/usr/bin',
        '/bin'],
      user   => 'root',
    }
  } else {
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
}