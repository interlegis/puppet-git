#clone.pp

define git::clone(   $source,
                $localtree = '/srv/git/',
                $real_name = false,
                $branch = false,
                $user = '') {

    include git::client

    if $real_name {
        $_name = $real_name
    }
    else {
        $_name = $name
    }

    if $user == '' {
      exec { "git_clone_exec_$localtree/$_name":
          cwd     => $localtree,
          command => "git clone $source $_name",
          creates => "$localtree/$_name/.git/",
	  require => Class["git::client"],
      }

      case $branch {
          false: {}
          default: {
              exec { "git_clone_checkout_${branch}_${localtree}/${_name}":
                  cwd     => "$localtree/$_name",
                  command => "git checkout --track -b $branch origin/$branch",
                  creates => "$localtree/$_name/.git/refs/heads/$branch",
	  	  require => Class["git::client"],
              }
          }
      }
    } else {
      exec { "git_clone_exec_$localtree/$_name":
          cwd     => $localtree,
          command => "sudo -u $user git clone $source $_name",
          creates => "$localtree/$_name/.git/",
          timeout => 0,
	  require => Class["git::client"],
      }

      case $branch {
          false: {}
          default: {
              exec { "git_clone_checkout_${branch}_${localtree}/${_name}":
                  cwd     => "$localtree/$_name",
                  command => "git checkout --track -b $branch origin/$branch",
                  creates => "$localtree/$_name/.git/refs/heads/$branch",
                  user    => $user,
                  require => User[$user],
                  timeout => 0,
	 	  require => Class["git::client"],
              }
          }
      }
    }
}
