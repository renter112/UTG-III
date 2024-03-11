using Godot;
using System;

public partial class blue_tank : CharacterBody2D
{
	Node2D turret;
	CharacterBody2D player;
	PackedScene bulletScene;
	RayCast2D raycast;
	Timer timer;
	float speed = 100f;
	
	public override void _Ready()
	{
		turret = GetNode<Node2D>("turret");
		player = GetNode<CharacterBody2D>("../tank_hull");
		timer = GetNode<Timer>("Timer");
		raycast = GetNode<RayCast2D>("RayCast2D");
		raycast.GlobalPosition = GlobalPosition;
		raycast.AddException(player);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		turret.Rotation = ( (player.Position - this.Position).Angle() );
		raycast.TargetPosition = player.Position - Position;
		if(timer.IsStopped() && !raycast.IsColliding())
		{
			shoot();
			timer.Start(3f);
		}
	}

	public void shoot()
	{
		RigidBody2D bullet = (RigidBody2D) ResourceLoader.Load<PackedScene>("res://Enemies/blueEnemy/big_bullet.tscn").Instantiate();
		bullet.GlobalPosition = this.Position;
		bullet.Rotation = ((player.Position - this.Position).Angle());
		bullet.GlobalPosition = ((player.Position - this.Position).Normalized() * 10) + this.Position;
		bullet.LinearVelocity = bullet.Transform.X * speed;
		GetParent().AddChild(bullet);
	}
}
