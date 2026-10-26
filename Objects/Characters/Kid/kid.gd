extends Character

func _ready():
	pre_order_dialog = Dialog.new([
		DLine.new("..."),
		DLine.new("(This kid is wearing such a huge jacket…)", "protag"),
		DLine.new("(Is it even that cold outside today?)", "protag"),
		DLine.new("(... I thought it was summer. What season was it again?)", "protag"),
		DLine.new("…May I have some milk?"),
		DLine.new("(They’re shivering…)", "protag"),
		DLine.new("…Please? Is it fast?"),
		DLine.new("I have to go home before it gets dark."),		
		DLine.new("My mom always told me it’s dangerous when you can’t see the sidewalk. "),
		DLine.new(" Cuz there’s bad people hiding. "),
		DLine.new("But I’m really really thirsty."),
		DLine.new("And I didn’t bring any water"),
		DLine.new("cuz I thought I’d only walk for a little bit."),
		DLine.new("I only have… 3 dollars and a quarter"),
		DLine.new("Don’t worry about the cost.", "protag")
	])

	
	evaluation_dialogs = {
		0.0: Dialog.new([
			DLine.new("Oh, I… Don’t know if I can drink that."),
			DLine.new("Sorry. I’m in a hurry, so…! ")
		]),
		0.5: Dialog.new([DLine.new("Thanks! I have to go now!")]),
	}
	
	order = Order.new(
	8,
	{
		Ingredients.MILK: 1
	}
)
