extends CharacterBody2D
const SPEED = 100.0

@onready var anim : AnimationPlayer = self.get_node("AnimationPlayer")

# Character state types
enum State {Idle, Move, Attack}

# State of the character
var state          : State          = State.Idle
var direction      : Direction.Type = Direction.Left
var attack_pressed : bool           = false
var input_vector   : Vector2        = Vector2.ZERO

func _process(_delta):
    # When we are in Attack State we skip input polling
    if self.state == State.Attack:
        return
    
    if Input.is_action_just_pressed("player_attack"):
        attack_pressed = true
        
    input_vector = Input.get_vector("player_left", "player_right", "player_up", "player_down")
    
# Changing the state can be dissallowed. For example we must wait until an attack finish
# until we can do other things again, like movement, or attacking again.
func state_change_allowed() -> bool:
    if self.state == State.Attack:
        if anim.is_playing():
            return false
    return true

func _physics_process(_delta):
    if state_change_allowed():
        # Attack has higher priority than movement
        if attack_pressed:
            self.state     = State.Attack
            attack_pressed = false
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
