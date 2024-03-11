using Godot;
using System;



public partial class OptionsMenu : Control
{

	
	private void _on_back_button_pressed()
	{
		var mainScene = ResourceLoader.Load<PackedScene>("res://Menus/MainMenu.tscn").Instantiate();
		GetTree().Root.AddChild(mainScene);
		QueueFree();
	}
}



