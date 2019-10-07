class WebRun < Run

  def self.run_this_step step, event, workflow
    if workflow
    execute_step step, event, workflow
  end

end
