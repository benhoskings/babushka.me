dep 'provision the bastard', :env, :host, :host_name do
  requires 'corkboard:host provisioned'.with(
    env: env,
    host: host,
    host_name: host_name,
    app_user: 'babushka',
    domain: 'babushka.me',
    app_name: 'babushka',
  )
end
