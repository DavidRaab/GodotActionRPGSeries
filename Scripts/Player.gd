extends CharacterBody2D
const SPEED = 100.0

@onready var anim : AnimationPlayer = self.get_node("AnimationPlayer")

# Character state types
enum State {Idle, Move, Attack}

# State of the character
var state     = State.Idle
var direction = Direction.Right

# Changing the state can be dissallowed. For example we must wait until an attack finish
# until we can do other things again, like movement, or attacking again.
func state_change_allowed() -> bool:
    if self.state == State.Attack:
        if anim.is_playing():
            return false
    return true

func _physics_process(_delta):
    # Get input information
    var is_attack    : bool    = Input.is_action_just_pressed("player_attack")
    var input_vector : Vector2 = Input.get_vector("player_left", "player_right", "player_up", "player_down")
    
    if state_change_allowed():
        # Attack has higher priority than movement
        if is_attack:
            self.state = State.Attack
        # Check Movement
        else:
            match Direction.from_vector2(input_vector):
                Direction.Center: 
                    self.state = State.Idle
                var d:
                    self.state     = State.Move
                    self.direction = d
    
    # Process State
    var dir : String = Direction.string(self.direction)
    match state:
        State.Attack: anim.play("Attack" + dir)
        State.Idle:   anim.play("Idle" + dir)
        State.Move:
            # Move Character
            self.velocity = input_vector * SPEED
            self.move_and_slide()
            # Play Animation
            anim.play(dir)
