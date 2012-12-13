define git::reset($localtree = '/srv/git/', $real_name = false, $clean = true,
  $user='') {

    #
    # Resource to reset changes in a working directory
    # Useful to undo any changes that might have occured in directories
    # that you want to pull for. This resource is automatically called
    # with every pull by default.
    #
    # You can set $clean to false to prevent a clean (removing untracked
    # files)
    #

    if $user == '' {
      exec { "git_reset_exec_$name":
          cwd     => $real_name ? {
              false   => "$localtree/$name",
              default => "$localtree/$real_name"
          },
          command => 'git reset --hard HEAD'
      }
    }
    else {
      exec { "git_reset_exec_$name":
          cwd     => $real_name ? {
              false   => "$localtree/$name",
              default => "$localtree/$real_name"
          },
          command => "sudo -u $user git reset --hard HEAD"
      }
    }

    if $clean {
        git::clean { $name:
            localtree => $localtree,
            real_name => $real_name,
            user      => $user
        }
    }
}
