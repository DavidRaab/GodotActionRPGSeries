extends CharacterBody2D
const SPEED = 100.0

# Editor Configuration
@export var SwordDamage : int = 1

@onready var anim      : AnimationPlayer  = $AnimationPlayer
@onready var health    : HealthComponent  = $HealthComponent
@onready var healthBar : ProgressBar      = $HealthBar
@onready var collision : CollisionShape2D = $PlayerCollision

# Character state types
enum State {Idle, Move, Attack, Roll}

# State of the character
var state     = State.Idle
var direction = Direction.Right

func _ready():
    $Sword/AreaDamage.damage = self.SwordDamage
    health.min_health_reached.connect(func(): self.queue_free())
    health.health_changed.connect(func(current,minv,maxv):
        healthBar.value = 100.0 / (maxv-minv) * current
    )

# Changing the state can be dissallowed. For example we must wait until an attack finish
# until we can do other things again, like movement, or attacking again.
func state_change_allowed() -> bool:
    if self.state == State.Attack:
        if anim.is_playing():
            return false
    if self.state == State.Roll:
        if anim.is_playing():
            return false
    return true

func _physics_process(_delta):
    # Get input information
    var is_attack    : bool    = Input.is_action_just_pressed("player_attack")
    var is_roll      : bool    = Input.is_action_just_pressed("player_roll")
    var input_vector : Vector2 = Input.get_vector("player_left", "player_right", "player_up", "player_down")
    
    # Set the State
    if state_change_allowed():
        # Attack/Roll has higher priority than movement
        if is_attack: self.state = State.Attack
        elif is_roll: self.state = State.Roll
        # No Action; Check Movement
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
        State.Roll:   
            self.velocity = Direction.to_vector2(direction) * SPEED
            self.move_and_slide()
            anim.play("Roll" + dir)
        State.Move:
            # Move Character
            self.velocity = input_vector * SPEED
            self.move_and_slide()
            # Play Animation
            anim.play(dir)

func take_damage(value:int) -> bool:
    # In Roll State player cannot be damaged
    if state == State.Roll: return false
    
    health.subtract_health(value)
    return true
    
