using Godot;
using System;

public partial class level_loader : Control
{
	// Called when the node enters the scene tree for the first time.
	public string level_title { get; set; } = "";
	public int attempt_counter {get; set; } = 0;
	public override void _Ready()
	{
		var gameScene = ResourceLoader.Load<PackedScene>("res://levelLoader/level.tscn").Instantiate();
		gameScene.Set("level_title", level_title); // Set the level_title property
		gameScene.Set("attempt_counter", attempt_counter); // Set the level_title property
		this.AddChild(gameScene);
	}

}
