extends CharacterBody2D
const SPEED = 100.0

@onready var anim : AnimationPlayer = self.get_node("AnimationPlayer")

# Character state types
enum State {Idle, Move, Attack}

# State of the character
var state     = State.Idle
var direction = Direction.Left

func _physics_process(_delta):
    # Get input information
    var is_attack = Input.is_action_pressed("player_attack")
    var dir       = Input.get_vector("player_left", "player_right", "player_up", "player_down")
    
    # Set State
    if self.state == State.Attack:
        if not anim.is_playing():
            self.state = State.Idle
    else:
        if is_attack:
            self.state = State.Attack
        elif dir == Vector2.ZERO:
            self.state = State.Idle
        else:
            self.state = State.Move
            self.direction = Direction.main_direction(dir)
        
    
    # Process State
    match state:
        State.Attack:
            # Play Animation
            match self.direction:
                Direction.Up:    anim.play("AttackUp")
                Direction.Right: anim.play("AttackRight")
                Direction.Down:  anim.play("AttackDown")
                Direction.Left:  anim.play("AttackLeft")
        State.Idle:
            # Play Animation
            match self.direction:
                Direction.Up:    anim.play("IdleUp")
                Direction.Right: anim.play("IdleRight")
                Direction.Down:  anim.play("IdleDown")
                Direction.Left:  anim.play("IdleLeft")
        State.Move:
            # Move Character
            self.velocity = dir * SPEED if dir else Vector2.ZERO
            self.move_and_slide()

            # Play Animation
            match self.direction:
                Direction.Up:    anim.play("Up")
                Direction.Right: anim.play("Right")
                Direction.Down:  anim.play("Down")
                Direction.Left:  anim.play("Left")
