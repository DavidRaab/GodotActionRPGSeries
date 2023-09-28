extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim : AnimationPlayer = self.get_node("AnimationPlayer")

# Direction the characters walks to
enum Direction {Up, Right, Down, Left, IdleUp, IdleRight, IdleDown, IdleLeft}
var direction = Direction.IdleRight

func update_direction():
    var x = velocity.x
    var y = velocity.y
    if self.velocity != Vector2.ZERO:
        if y < -0.01 && abs(y) > abs(x): 
            self.direction = Direction.Up
        elif y >  0.01 && abs(y) > abs(x):
            self.direction = Direction.Down
        elif x >  0.01:
            self.direction = Direction.Right
        else:
            self.direction = Direction.Left
    else:
        if   self.direction == Direction.Up:    self.direction = Direction.IdleUp
        elif self.direction == Direction.Right: self.direction = Direction.IdleRight
        elif self.direction == Direction.Down:  self.direction = Direction.IdleDown
        elif self.direction == Direction.Left:  self.direction = Direction.IdleLeft
        

func _physics_process(_delta):
    # get input vector und move character
    var dir       = Input.get_vector("player_left", "player_right", "player_up", "player_down")
    self.velocity = dir * SPEED if dir else Vector2.ZERO
    self.move_and_slide()
    
    # Update the direction
    self.update_direction()

    # play correct animation depending on direction
    if   self.direction == Direction.Up       : anim.play("Up")
    elif self.direction == Direction.Down     : anim.play("Down")
    elif self.direction == Direction.Left     : anim.play("Left")
    elif self.direction == Direction.Right    : anim.play("Right")
    elif self.direction == Direction.IdleUp   : anim.play("IdleUp")
    elif self.direction == Direction.IdleRight: anim.play("IdleRight")
    elif self.direction == Direction.IdleDown : anim.play("IdleDown")
    else                                      : anim.play("IdleLeft")
    
    
