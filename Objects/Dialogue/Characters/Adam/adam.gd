extends Character

func _ready():
	pre_order_dialog = Dialog.new([
		"Hello",
		"Sup"
	])
	
	evaluation_dialogs = {
		0.0: Dialog.new(["This is bad"]),
		0.5: Dialog.new(["This is okay"]),
		0.9: Dialog.new(["This is good!"])
	}
	
	order = Order.new(
	8,
	{
		Ingredients.ESPRESSO: 1,
		Ingredients.MILK: 3
	}
)
