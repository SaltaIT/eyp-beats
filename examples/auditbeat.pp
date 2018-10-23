class { 'beats::auditbeat':
  output_file_dir => '/var/log/audit',
}

# -a always,exit -F arch=b64 -S execve,execveat -k exec
beats::auditbeat::syscallrule { 'execve':
  actions => [ 'always', 'exit' ],
  syscalls => [ 'execve' ],
}
