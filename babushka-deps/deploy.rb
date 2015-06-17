dep 'before deploy', :old_id, :new_id, :branch, :env do
  # requires 'db backed up'
end

dep 'on deploy', :old_id, :new_id, :branch, :env do
  requires 'built'
  requires 'common:when path changed'.with('db/migrate/', 'conversation:migrated db', old_id, new_id, env)
end

dep 'built', template: 'task' do
  run {
    shell "bundle exec pith -i pith/ -o public/ build", :log => true
  }
end

dep 'db backed up' do
  @backup_time = Time.now

  def backup_prefix; "~/sqldumps".p end
  def refspec; shell "git rev-parse --short HEAD" end
  def sqldump; backup_prefix / "babushka.me-#{@backup_time.strftime("%Y-%m-%d-%H:%M:%S")}-#{refspec}.psql" end
  def backup_path; "#{sqldump}.gz".p end

  met? { backup_path.exists? }
  before { backup_prefix.mkdir }
  meet { log_shell "Creating #{sqldump} from babushka.me", "pg_dump babushka.me > '#{sqldump}' && gzip -9 '#{sqldump}'" }
  after { log_shell "Removing old sqldumps", %Q{ls -t -1 #{backup_prefix} | tail -n+6 | while read f; do rm "#{backup_prefix}/$f"; done} }
end
