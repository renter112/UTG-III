using Godot;
using System;

public partial class orange_tank : CharacterBody2D
{
	Node2D turret;
	CharacterBody2D player;
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
		RigidBody2D bullet = (RigidBody2D) ResourceLoader.Load<PackedScene>("res://player/bullet.tscn").Instantiate();
		RigidBody2D bullet2 = (RigidBody2D) ResourceLoader.Load<PackedScene>("res://player/bullet.tscn").Instantiate();
		RigidBody2D bullet3 = (RigidBody2D) ResourceLoader.Load<PackedScene>("res://player/bullet.tscn").Instantiate();
		bullet.Scale =  new Vector2(0.4f,0.4f);
		bullet2.Scale = new Vector2(.4f,.4f);
		bullet3.Scale = new Vector2(.4f,.4f);
		bullet.GlobalPosition = this.Position;
		bullet2.GlobalPosition = this.Position;
		bullet3.GlobalPosition = this.Position;
		bullet.Rotation = ((player.Position - this.Position).Angle());
		bullet2.Rotation = ((player.Position - this.Position).Angle() + (float)Math.PI/6);
		bullet3.Rotation = ((player.Position - this.Position).Angle() - (float)Math.PI/6);
		bullet.GlobalPosition = ((player.Position - this.Position).Normalized() * 10) + this.Position;
		bullet2.GlobalPosition = (Vector2.FromAngle(bullet2.Rotation) * 10) + this.Position;
		bullet3.GlobalPosition = (Vector2.FromAngle(bullet3.Rotation) * 10) + this.Position;
		bullet.LinearVelocity = bullet.Transform.X * speed;
		bullet2.LinearVelocity = bullet2.Transform.X * speed;
		bullet3.LinearVelocity = bullet3.Transform.X * speed;
		GD.Print("T pos: "+this.Position);
		GD.Print("B1 pos: " +bullet.Position);
		GD.Print("B2 pos: "+bullet2.Position);
		GD.Print("B3 pos: "+bullet3.Position);
		GetParent().AddChild(bullet);
		GetParent().AddChild(bullet2);
		GetParent().AddChild(bullet3);
	}

}


