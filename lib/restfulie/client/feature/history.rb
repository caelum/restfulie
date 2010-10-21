module Restfulie::Client::Feature::History

  def snapshots
    @snapshots ||= []
  end

  def max_to_remind
    10
  end

  def history(number)
    snapshots[snapshots.size + number] || raise("Undefined snapshot for #{number}, only containing #{@snapshots.size} snapshots.")
  end

  def make_snapshot(request)
    snapshots.shift if snapshot_full?
    snapshots << request
  end
  
  private

  def snapshot_full?
    snapshots.size >= max_to_remind
  end

end