class { 'beats::auditbeat':
  output_file_dir => '/var/log/audit',
}

# -a always,exit -F arch=b64 -S execve,execveat -k exec
beats::auditbeat::syscallrule { 'execve':
  actions  => [ 'always', 'exit' ],
  syscalls => [ 'execve' ],
}

beats::auditbeat::fsrule { 'exec_tmp':
  path        => '/tmp',
  permissions => 'x',
}

class { 'beats::filebeat':
  logstash_hosts => [ '127.0.0.1:5044'],
}

beats::filebeat::input { 'auditbeat':
  paths                => [ '/var/log/audit/auditbeat' ],
  fields               => { 'auditbeat' => 'true' },
  json_keys_under_root => true,
}
