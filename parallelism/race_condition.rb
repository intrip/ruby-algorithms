class Sheep
  def initialize
    @shorn = false
  end

  def shorn?
    @shorn
  end

  def shear!
    puts "shearing..."
    @shorn = true
  end
end


sheep = Sheep.new
semaphore = Mutex.new

5.times.map do
  Thread.new do
    # semaphore.synchronize do
      unless sheep.shorn?
        sheep.shear!
      end
    # end
  end
end.each(&:join)
# sometimes the same sheep is sheared multiple times
