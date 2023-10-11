class_name Direction
enum Type {Up, Right, Down, Left}

const Up    = Type.Up
const Right = Type.Right
const Down  = Type.Down
const Left  = Type.Left

static func main_direction(vec:Vector2, default=Type.Left) -> Direction.Type:
    var x = vec.x
    var y = vec.y
    if vec != Vector2.ZERO:
        if   y < -0.01 && abs(y) > abs(x): return Up
        elif y >  0.01 && abs(y) > abs(x): return Down
        elif x >  0.01:                    return Right
        else:                              return Left
    else:
        return default
