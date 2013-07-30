class glassfish-setup (
    $release = "4.0",
    $target = "/usr/share/glassfish4"
) {

    exec{'download glassfish':
        command     => "wget -O /tmp/glassfish-${release}.zip --no-check-certificate http://download.java.net/glassfish/${release}/release/glassfish-${release}.zip",
        user        => 'root',
        path        => '/usr/bin/',
        creates     => "/tmp/glassfish-${release}.zip",
    }

    exec{ 'unzip glassfish':
        command     => "unzip /tmp/glassfish-${release}.zip",
        cwd         => "/usr/share/",
        path        => "/usr/bin",
        require     => [Exec['download glassfish'],Package["unzip"]],
        creates     => "${target}",
    }

    file { "${target}":
        backup      => false,
        checksum    => none,
        owner       => "glassfish",
        group       => "glassfish",
        recurse     => true,
        require     => [Exec["unzip glassfish"], User["glassfish"], Group["glassfish"]],
    }

    group { "glassfish":
        system  => true,
    }

    user { "glassfish":
        system      => true,
        require     => Group["glassfish"],
        home        => "${target}",
    }

    file { "/etc/profile.d/glassfish.sh":
        content => "pathmunge ${target}/bin",
        owner   => root,
        mode    => 755,
    }

}