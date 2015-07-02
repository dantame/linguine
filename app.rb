require_relative 'lib/main'

class LinguineRackApp
  attr_reader :app

  def initialize app = nil, translator
    @app = app
    @linguine = Linguine::Main.new translator
  end

  def call env
    status, headers, res = @app.call(env)
    response = @linguine.parse(res, env)
    [status, headers, response]
  end
end