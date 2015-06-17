BabushkaMe::Application.routes.draw do
  get "/up", :to => "bootstrap#up", :via => :get, :format => :sh
  get "/up/:ref", :to => "bootstrap#up", :via => :get, :format => :sh, :ref =>  /[^\/]*/

  get '/docs' => redirect("/")
  get '/rdoc' => redirect("http://rubydoc.info/github/benhoskings/babushka/master/frames")
  get '/mailing_list' => redirect("http://groups.google.com/group/babushka_app")

  get "/refs/heads/:refname" => redirect("http://github.com/benhoskings/babushka/tree/%{refname}"), refname: /[0-9a-z_\-\.]+/i
  get "/issues/:id" => redirect("http://github.com/benhoskings/babushka/issues#issue/%{id}"), id: /\d+/
  get "/:id" => redirect("http://github.com/benhoskings/babushka/commit/%{id}"), id: /[0-9a-f]{7,40}/i
end
