class_name Direction
enum Type {Center, Up, Right, Down, Left}

const Center = Type.Center
const Up     = Type.Up
const Right  = Type.Right
const Down   = Type.Down
const Left   = Type.Left

static func from_vector2(vec:Vector2) -> Direction.Type:
    var x = vec.x
    var y = vec.y
    if vec == Vector2.ZERO:
        return Center
    else:
        # Left or Right
        if abs(x) > abs(y):
            return Right if x >= 0 else Left
        # Up or Down
        else:
            return Down if y >= 0 else Up

static func string(direction:Direction.Type) -> String:
    match direction:
        Center: return "Center"
        Up:     return "Up"
        Right:  return "Right"
        Down:   return "Down"
        Left:   return "Left"
        _:      return ""
