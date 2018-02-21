use v6.c;

use DateTime::Format;

my @commits = (
  'fb69ec1e414b9dcc717ccc378af56c113539819c' => DateTime.new('2018-02-14T05:17:00-0500'),
  #'6077c85bd4cbc5702e2c8add90b2e516d4c428e' => DateTime.new('2018-02-15T11:05:00-0500'),
  #'6c0740bbbd656110a248c318afc6320377247a9' => DateTime.new('2018-02-15T18:51:00-0500'),
  #'3666b0a0e2af401b2380ca0ae67926f7356c9ec' => DateTime.new('2018-02-16T02:08:00-0500'),
  #'161914cf4bbc9b7441dff1b1fea37bf8ce2f2d6' => DateTime.new('2018-02-16T04:11:00-0500'),
  #'3408d30c624a8c87ca7302e155cac7520ebee17' => DateTime.new('2018-02-16T05:27:00-0500'),
  #'12c8cd9fd6f320e50671107c97a0da6d9683daa' => DateTime.new('2018-02-16T13:50:00-0500'),
  #'08dd492ada4af521baf81f78a57372f85e8fbff' => DateTime.new('2018-02-17T07:59:00-0500'),
  #'f3153bdf3c0bf2e3749400c1bc084bbde3da32a' => DateTime.new('2018-02-17T12:52:00-0500'),
  #'7129a2ac8011d8a9b492fb113f109c5469e6327' => DateTime.new('2018-02-17T14:35:00-0500'),
  #'53264b016f6cef0b73475517067ee146f322c6e' => DateTime.new('2018-02-18T23:12:00-0500'),
  #'e41130c28291e278d9296ad524a29eec9c890e5' => DateTime.new('2018-02-18T23:20:00-0500'),
  #'ebb1fc524b74fbc507222462971ccef0828c421' => DateTime.new('2018-02-19T11:32:00-0500'),
  #'c547fb7f81f4facc62d7d8a3272f42966ee0c1b' => DateTime.new('2018-02-19T12:47:00-0500'),
  #'0dab19f9780260ee7f9258e0e82f31e8d0ef42b' => DateTime.new('2018-02-19T14:07:00-0500'),
  #'0a87f5715e5dfaecc6f1b1a8135d74dd8690244' => DateTime.new('2018-02-19T17:47:00-0500'),
  #'e8195cd4644e1f182e6130e6444a7f247f58991' => DateTime.new('2018-02-19T19:58:00-0500'),
  #'a9b55124c70ea055d00c0c398422b167c8b4c34' => DateTime.new('2018-02-19T22:43:00-0500'),
  #'71105777bf12cd502e367f4f7bccc9443ac260e' => DateTime.new('2018-02-19T22:47:00-0500')
);

for @commits -> $c {
  my $new_time = strftime("%a %b %e %H:%M:%S %Y %z", $c.value);
  #my $new_time = sprintf (
  #  ("{ $month_date } %2d %02d:%02d:%02d %4d -%4d",
  #  .day, .hour, .minute, .second, .year, .offset-in-hours * 100
  #);
  say "Commit time {$c.key} is '{ $new_time }'";
  run 'git', 'filter-branch', '-f', '--env-filter',
      'if [ \$GIT_COMMIT = {$c.key} ]; then export GIT_AUTHOR_DATE=\"{ $new_time }\" \; export GIT_COMMITTER_DATE=\"{ $new_time }\"; fi';
}
