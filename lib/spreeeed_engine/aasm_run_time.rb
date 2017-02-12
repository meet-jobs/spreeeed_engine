module SpreeeedEngine
  class AasmRunTime
    # optional args parameter can be omitted, but if you define initialize
    # you must accept the model instance as the first parameter to it.
    def initialize(job, args = {})
      @job = job
    end

    def call
      log "Job was running for #{@job.run_time} seconds"
    end
  end
end
