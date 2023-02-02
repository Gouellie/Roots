extends ResolveBehavior
class_name ResourceResolveBehavior

export (String)var identifier : String = "water"
export (int)var amount : int = 1

func _init():
	amount = int(max(amount, 0))
