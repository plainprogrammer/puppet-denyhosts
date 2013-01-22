class {'denyhosts':
  always_allow => ['10.0.1.1'],
  always_deny  => ['10.1.0.1', '10.1.0.2'],
  use_sync     => true,
  autoupdate   => true,
}