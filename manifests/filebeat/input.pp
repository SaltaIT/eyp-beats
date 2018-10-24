define beats::filebeat::input (
                                $input_name           = $name,
                                $order                = '42',
                                $type                 = 'log',
                                $enabled              = true,
                                $paths                = [],
                                $scan_frequency       = undef,
                                $json_keys_under_root = undef,
                                $exclude_lines        = [],
                                $include_lines        = [],
                                $exclude_files        = [],
                                $fields               = [],
                                $multiline_pattern    = undef,
                                $multiline_negate     = undef,
                                $multiline_match      = undef,
                              ) {
  concat::fragment{ "filebeat.yml input ${input_name} - ${name}":
    target  => '/etc/filebeat/filebeat.yml',
    order   => "b${order}",
    content => template("${module_name}/filebeat/input.erb"),
  }
}
