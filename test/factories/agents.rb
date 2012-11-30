Factory.sequence :agent_email do |n|
  "whamd@server#{n}.warnerbros.com"
end

Factory.define :agent do |agent|
  agent.email                 { Factory.next :agent_email }
  agent.password              { "password" }
  agent.password_confirmation { "password" }
#  agent.api_key               { "API KEY" }
end

Factory.define :email_confirmed_agent, :parent => :agent do |agent|
  agent.email_confirmed { true }
end

Factory.define :activated_agent, :parent => :email_confirmed_agent do |agent|
  agent.state { "active" }
end