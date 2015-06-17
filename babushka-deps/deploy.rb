dep 'on deploy', :old_id, :new_id, :branch, :env do
  requires 'built'
end

dep 'built', template: 'task' do
  run {
    shell "bundle exec pith -i pith/ -o public/ build", :log => true
  }
end
