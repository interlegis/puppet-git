define git::clean($localtree = '/srv/git/', $real_name = false, $user = '') {

    #
    # Resource to clean out a working directory
    # Useful for directories you want to pull from upstream, but might
    # have added files. This resource is applied for all pull resources,
    # by default.
    #
    if $user == '' {
      exec { "git_clean_exec_$name":
          cwd     => $real_name ? {
              false   => "$localtree/$name",
              default => "$localtree/$real_name"
          },
          command => 'git clean -d -f'
      }
    }
    else {
      exec { "git_clean_exec_$name":
          cwd     => $real_name ? {
              false   => "$localtree/$name",
              default => "$localtree/$real_name"
          },
          command => "sudo -u $user git clean -d -f"
      }
    }
}
