use "collections"

actor Main
  new create(env: Env) =>
    try
      let max_num = env.args(1)?.usize()?
      let seq_length = env.args(2)?.usize()?
      let manager = Manager(env, max_num, seq_length)
      manager.initiate_search()
    else
      env.out.print("Usage: lukas <max_num> <seq_length>")
    end

actor Manager
  let _env: Env
  let _max_num: USize
  let _seq_length: USize
  let _valid_starts: Array[USize] ref = Array[USize]
  var _active_tasks: USize = 0

  new create(env: Env, max_num: USize, seq_length: USize) =>
    _env = env
    _max_num = max_num
    _seq_length = seq_length

  be initiate_search() =>
    let task_size = determine_task_size()
    var range_start: USize = 1
    let range_end = _max_num + 1
    
    while range_start <= range_end do
      let range_finish = ((range_start + task_size) - 1).min(range_end)
      _active_tasks = _active_tasks + 1
      Processor(this, range_start, range_finish, _seq_length)
      range_start = range_finish + 1
    end

  fun determine_task_size(): USize =>
    let total_range = _max_num
    ((total_range / 100).max(1000)).min(total_range)

  be record_valid_start(start_num: USize) =>
    _valid_starts.push(start_num)

  be task_finished() =>
    _active_tasks = _active_tasks - 1
    if _active_tasks == 0 then
      display_results()
    end

  fun ref display_results() =>
    Sort[Array[USize], USize](_valid_starts)
    if _valid_starts.size() > 0 then
      for valid_start in _valid_starts.values() do
        _env.out.print(valid_start.string())
      end
    else
      _env.out.print("No solution")
    end

actor Processor
  let _manager: Manager
  let _range_start: USize
  let _range_end: USize
  let _seq_length: USize

  new create(manager: Manager, range_start: USize, range_end: USize, seq_length: USize) =>
    _manager = manager
    _range_start = range_start
    _range_end = range_end
    _seq_length = seq_length
    process_range()

  be process_range() =>
    var current_num = _range_start
    while current_num <= _range_end do
      if is_valid_start(current_num) then
        _manager.record_valid_start(current_num)
      end
      current_num = current_num + 1
    end
    _manager.task_finished()

  fun is_valid_start(start_num: USize): Bool =>
    var sum_squares: U128 = 0
    for i in Range(0, _seq_length) do
      sum_squares = sum_squares + ((start_num + i).u128() * (start_num + i).u128())
    end
    is_perfect_square(sum_squares)

  fun is_perfect_square(num: U128): Bool =>
    if num == 0 then
      true
    else
      var x: U128 = num
      var y: U128 = (x + 1) / 2
      while y < x do
        x = y
        y = (x + (num / x)) / 2
      end
      (x * x) == num
    end