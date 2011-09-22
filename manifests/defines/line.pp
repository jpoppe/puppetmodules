define line (
  $file, 
  $line,
  $ensure = 'present'
  ) {

  case $ensure {

    default : {

      err ( "unknown ensure value ${ensure}" )

    }

    present: {

      exec { "/bin/echo '${line}' >> '${file}'":
        unless => "/bin/grep -qFx '${line}' '${file}'"
      }

    }

    absent: {

      exec { "/usr/bin/perl -ni -e 'print unless /^\\Q${line}\\E\$/' '${file}'":
        onlyif => "/bin/grep -qFx '${line}' '${file}'"
      }

    }

    uncomment: {

      exec { "/bin/sed -i -e'/${line}/s/^#\\+//' '${file}'":
        onlyif => "/bin/grep '${line}' '${file}' | /bin/grep '^#' | /usr/bin/wc -l"
      }
    }

    comment: {

      exec { "/bin/sed -i -e'/${line}/s/^\\(.\\+\\)$/#\\1/' '${file}'":
        onlyif => "/usr/bin/test `/bin/grep '${line}' '${file}' | /bin/grep -v '^#' | /usr/bin/wc -l` -ne 0"
      }

    }

  }
}
