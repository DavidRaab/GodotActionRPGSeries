extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim     : AnimationPlayer = self.get_node("AnimationPlayer")
@onready var animTree : AnimationTree   = $AnimationTree
@onready var animState :AnimationNodeStateMachinePlayback = animTree.get("parameters/playback")

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
        match self.direction:
            Direction.Up:    self.direction = Direction.IdleUp
            Direction.Right: self.direction = Direction.IdleRight
            Direction.Down:  self.direction = Direction.IdleDown
            Direction.Left:  self.direction = Direction.IdleLeft
        

func _physics_process(_delta):
    # get input vector und move character
    var dir       = Input.get_vector("player_left", "player_right", "player_up", "player_down")
    self.velocity = dir * SPEED if dir else Vector2.ZERO
    self.move_and_slide()
    
    var normalized = self.velocity.normalized()
    if normalized == Vector2.ZERO:
        animState.travel("Idle")
    else:
        animTree.set("parameters/Idle/blend_position", normalized)
        animTree.set("parameters/Run/blend_position", normalized)
        animState.travel("Run")
    
    # Update the direction
#    self.update_direction()

    # play correct animation depending on direction
#    match self.direction:
#        Direction.Up        : anim.play("Up")
#        Direction.Down      : anim.play("Down")
#        Direction.Left      : anim.play("Left")
#        Direction.Right     : anim.play("Right")
#        Direction.IdleUp    : anim.play("IdleUp")
#        Direction.IdleRight : anim.play("IdleRight")
#        Direction.IdleDown  : anim.play("IdleDown")
#        _                   : anim.play("IdleLeft")
    
    
