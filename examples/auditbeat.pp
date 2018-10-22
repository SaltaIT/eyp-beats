class { 'beats::auditbeat':
  output_file_dir => '/var/log/audit',
}
