class WebRun < Run

  def self.run_this_step step, event, workflow
    execute_step step, event, workflow
  end

end
