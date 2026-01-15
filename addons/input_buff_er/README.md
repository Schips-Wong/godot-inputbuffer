# Input-buff-er: Generic purpose input buffer for Godot 4.3

This plugin adds the **Buffer** class for managing the execution of one player action.

It can both buffer one player input for a set amount of time to run the action when allowed, and buffer the potential of an action for a set amount of time to run it when a player input is recieved.


Fork from : `https://github.com/TamerSoup625/godot-buff-er`

## Example use

### Single input buffer

```gdscript
var _fire_buffer = InputBuffer.new(0.2)

func _process(delta):
	_fire_buffer.update(
			Input.is_action_just_pressed("fire"),
			ammo > 0,
			delta,
	)
	if _fire_buffer.should_run_action():
		shoot_bullet()
```

## Multi input buffer

```gdscript
var _input_buffer = MultiInputBuffer.new()

func _ready():
    _input_buffer.add_action("jump", 0.2, 0.1)  # pre_buffer 0.2s, post_buffer 0.1s
    _input_buffer.add_action("attack", 0.1, 0.0)
    _input_buffer.add_action("dash", 0.15, 0.05)

func _physics_process(delta):
    _input_buffer.update({
        "jump": Input.is_action_just_pressed("jump"),
        "attack": Input.is_action_just_pressed("attack"),
        "dash": Input.is_action_just_pressed("dash"),
    }, {
        "jump": is_on_floor(),
        "attack": can_attack,
        "dash": can_dash,
    }, delta)

    if _input_buffer.should_run_action("jump"):
        jump()
    if _input_buffer.should_run_action("attack"):
        attack()
    if _input_buffer.should_run_action("dash"):
        dash()
```
