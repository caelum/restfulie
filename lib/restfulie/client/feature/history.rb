module Restfulie::Client::Feature::History

  def snapshots
    @snapshots ||= []
  end

  def max_to_remind
    10
  end

  def history(number)
    snapshots[number] || raise "Undefined snapshot for #{number}"
  end

  def make_snapshot(request)
    snapshots.shift if snapshot_full?
    snapshots << snapshot
  end
  
  private

  def snapshot_full?
    snapshots.size >= request.max_to_remind
  end

end