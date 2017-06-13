class Interval
  # Note that time is in ms.
  def initialize(time=0)
    @interval = `setInterval(function(){#{yield}}, time)`
  end

  def stop
    `clearInterval(#@interval)`
  end
end
