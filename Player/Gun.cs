using Godot;
using System;

public partial class Gun : Node2D
{
	
	[Export] PackedScene bulletScene;
	[Export] float bulletSpeed = 75f;
	[Export] float bps = 2f;
	[Export] float fireRate;
	public int shotsFired = 0;
	float timer = 0;
	Area2D tur;
	CharacterBody2D tank; 
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		fireRate = 1/bps;
		tank = GetParent().GetParent<CharacterBody2D>();
		tur = GetParent<Area2D>();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if(Input.IsActionPressed("fire") && timer > fireRate){
			RigidBody2D bullet = bulletScene.Instantiate<RigidBody2D>();
			bullet.GlobalPosition = new Vector2(tank.Position.X, tank.Position.Y);
			bullet.LookAt(GetGlobalMousePosition());
			bullet.LinearVelocity = bullet.Transform.X * bulletSpeed;
			bullet.GlobalPosition = new Vector2(GlobalPosition.X, GlobalPosition.Y);
			GetParent().GetParent().GetParent().AddChild(bullet);
			timer = 0f;
			shotsFired++;
		}
		else
		{
			timer += (float)delta;
		}
	}
}
