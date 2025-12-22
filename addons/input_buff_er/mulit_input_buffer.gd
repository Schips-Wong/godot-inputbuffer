@icon("res://addons/input_buff_er/buffer_icon.svg")
class_name MultiInputBuffer
extends RefCounted

## Generic purpose buffer for managing multiple input actions with buffering.
##
## [MultiInputBuffer] extends the functionality of [InputBuffer] to support multiple actions simultaneously.
## It internally manages a collection of [InputBuffer] instances, one for each registered action.
##
## Example usage:
## [codeblock]
## var _input_buffer = MultiInputBuffer.new()
##
## func _ready():
##     _input_buffer.add_action("jump", 0.2, 0.1)  # pre_buffer 0.2s, post_buffer 0.1s
##     _input_buffer.add_action("attack", 0.1, 0.0)
##     _input_buffer.add_action("dash", 0.15, 0.05)
##
## func _physics_process(delta):
##     _input_buffer.update({
##         "jump": Input.is_action_just_pressed("jump"),
##         "attack": Input.is_action_just_pressed("attack"),
##         "dash": Input.is_action_just_pressed("dash"),
##     }, {
##         "jump": is_on_floor(),
##         "attack": can_attack,
##         "dash": can_dash,
##     }, delta)
##
##     if _input_buffer.should_run_action("jump"):
##         jump()
##     if _input_buffer.should_run_action("attack"):
##         attack()
##     if _input_buffer.should_run_action("dash"):
##         dash()
## [/codeblock]

## The default value of [member autoflush_on_success].
const DEFAULT_AUTOFLUSH_ON_SUCCESS = true

## Dictionary to store individual action buffers
var _action_buffers: Dictionary = {}

## Add a new action to the buffer manager.
## @param action_name The name of the action to add.
## @param pre_buffer The maximum pre-buffer time for this action.
## @param post_buffer The maximum post-buffer time for this action.
## @param autoflush Whether to automatically flush the buffer on success for this action.
func add_action(action_name: String, pre_buffer: float = 0.0, post_buffer: float = 0.0, autoflush: bool = DEFAULT_AUTOFLUSH_ON_SUCCESS) -> void:
	_action_buffers[action_name] = InputBuffer.new(pre_buffer, post_buffer, autoflush)

## Remove an action from the buffer manager.
## @param action_name The name of the action to remove.
func remove_action(action_name: String) -> void:
	if _action_buffers.has(action_name):
		_action_buffers.erase(action_name)

## Check if the buffer manager contains a specific action.
## @param action_name The name of the action to check.
## @return True if the action exists, false otherwise.
func has_action(action_name: String) -> bool:
	return _action_buffers.has(action_name)

## Get the list of all registered actions.
## @return An array containing all action names.
func get_all_actions() -> Array:
	return _action_buffers.keys()

## Update the state of all or specific action buffers.
## @param input_dict A dictionary mapping action names to their input state (true/false).
## @param allow_dict A dictionary mapping action names to their allow state (true/false).
## @param delta The time delta for frame-independent calculations.
func update(input_dict: Dictionary, allow_dict: Dictionary, delta: float) -> void:
	# Update all action buffers
	for action_name in _action_buffers.keys():
		var input = input_dict.get(action_name, false)
		var allow = allow_dict.get(action_name, false)
		_action_buffers[action_name].update(input, allow, delta)

## Check if a specific action should run.
## @param action_name The name of the action to check.
## @return True if the action should run, false otherwise.
## @throws If the action does not exist.
func should_run_action(action_name: String) -> bool:
	if not _action_buffers.has(action_name):
		push_error("Action '" + action_name + "' not found in MultiInputBuffer")
		return false
	return _action_buffers[action_name].should_run_action()

## Get the action result for a specific action.
## @param action_name The name of the action to check.
## @return The ActionResult for the action.
## @throws If the action does not exist.
func get_action_result(action_name: String) -> InputBuffer.ActionResult:
	if not _action_buffers.has(action_name):
		push_error("Action '" + action_name + "' not found in MultiInputBuffer")
		return InputBuffer.ActionResult.DO_NOT
	return _action_buffers[action_name].get_action_result()

## Flush a specific action buffer.
## @param action_name The name of the action to flush.
## @throws If the action does not exist.
func flush_action(action_name: String) -> void:
	if not _action_buffers.has(action_name):
		push_error("Action '" + action_name + "' not found in MultiInputBuffer")
		return
	_action_buffers[action_name].flush()

## Flush all action buffers.
func flush_all_actions() -> void:
	for buffer in _action_buffers.values():
		buffer.flush()

## Get the pre-buffer time left for a specific action.
## @param action_name The name of the action to check.
## @return The pre-buffer time left.
## @throws If the action does not exist.
func get_pre_buffer_time_left(action_name: String) -> float:
	if not _action_buffers.has(action_name):
		push_error("Action '" + action_name + "' not found in MultiInputBuffer")
		return 0.0
	return _action_buffers[action_name].get_pre_buffer_time_left()

## Get the post-buffer time left for a specific action.
## @param action_name The name of the action to check.
## @return The post-buffer time left.
## @throws If the action does not exist.
func get_post_buffer_time_left(action_name: String) -> float:
	if not _action_buffers.has(action_name):
		push_error("Action '" + action_name + "' not found in MultiInputBuffer")
		return 0.0
	return _action_buffers[action_name].get_post_buffer_time_left()

## Get the pre-buffer time passed for a specific action.
## @param action_name The name of the action to check.
## @return The pre-buffer time passed.
## @throws If the action does not exist.
func get_pre_buffer_time_passed(action_name: String) -> float:
	if not _action_buffers.has(action_name):
		push_error("Action '" + action_name + "' not found in MultiInputBuffer")
		return 0.0
	return _action_buffers[action_name].get_pre_buffer_time_passed()

## Get the post-buffer time passed for a specific action.
## @param action_name The name of the action to check.
## @return The post-buffer time passed.
## @throws If the action does not exist.
func get_post_buffer_time_passed(action_name: String) -> float:
	if not _action_buffers.has(action_name):
		push_error("Action '" + action_name + "' not found in MultiInputBuffer")
		return 0.0
	return _action_buffers[action_name].get_post_buffer_time_passed()

## Check if a specific action will flush next frame.
## @param action_name The name of the action to check.
## @return True if the action will flush next frame, false otherwise.
## @throws If the action does not exist.
func will_flush_next_frame(action_name: String) -> bool:
	if not _action_buffers.has(action_name):
		push_error("Action '" + action_name + "' not found in MultiInputBuffer")
		return false
	return _action_buffers[action_name].will_flush_next_frame()

## Set the pre-buffer time for a specific action.
## @param action_name The name of the action to modify.
## @param pre_buffer The new pre-buffer time.
## @throws If the action does not exist.
func set_pre_buffer_time(action_name: String, pre_buffer: float) -> void:
	if not _action_buffers.has(action_name):
		push_error("Action '" + action_name + "' not found in MultiInputBuffer")
		return
	_action_buffers[action_name].pre_buffer_max_time = pre_buffer

## Set the post-buffer time for a specific action.
## @param action_name The name of the action to modify.
## @param post_buffer The new post-buffer time.
## @throws If the action does not exist.
func set_post_buffer_time(action_name: String, post_buffer: float) -> void:
	if not _action_buffers.has(action_name):
		push_error("Action '" + action_name + "' not found in MultiInputBuffer")
		return
	_action_buffers[action_name].post_buffer_max_time = post_buffer

## Set the autoflush on success flag for a specific action.
## @param action_name The name of the action to modify.
## @param autoflush The new autoflush value.
## @throws If the action does not exist.
func set_autoflush_on_success(action_name: String, autoflush: bool) -> void:
	if not _action_buffers.has(action_name):
		push_error("Action '" + action_name + "' not found in MultiInputBuffer")
		return
	_action_buffers[action_name].autoflush_on_success = autoflush
