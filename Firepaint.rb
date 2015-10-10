require 'gosu'

class Firepaint < Gosu::Window

	INTENSITY = 30
	GRAVITY = 0.1
	WHITE = Gosu::Color.new(255, 255, 255, 255)
	Particle = Struct.new(:x, :y, :xs, :ys, :r, :g, :b)

	def initialize(width = 640, height = 480, fullscreen = true)
		super
		self.caption = "Firepaint"
		
		@width = width
		@height = height
		
		@particles = []
		@r = Random.new
	end
	
	def button_down(id)
		close if id == Gosu::KbEscape
	end
	
	def update
		update_particles
		create_particles(mouse_x, mouse_y, @r.rand(1..INTENSITY)) if Gosu::button_down?(Gosu::MsLeft)
	end
	
	def create_particles(x, y, count)
		anstep = 360 / count
		an = @r.rand(anstep)
		count.times do
			@particles.push(Particle.new(x, y,
												Math.cos(an) * @r.rand(3...4),
												Math.sin(an) * @r.rand(3..4),
												255, 255, 255))
			an += anstep
		end
	end
	
	def update_particles
		@particles.each do |particle|
			particle.x += particle.xs
			particle.y += particle.ys
			particle.ys += GRAVITY
			particle.b -= 5 if particle.b > 0
			particle.g -= 3 if particle.b > 0
			particle.r -= 1 if particle.b > 0
		end
		@particles.delete_if { |particle| !particle.x.between?(0, @width) || particle.y >= @height || particle.r.zero? }
	end
	
	def draw
		@particles.each do |particle|
			draw_particle(particle.x, particle.y, Gosu::Color.new(particle.r, particle.g, particle.b))
		end
		draw_particle(mouse_x, mouse_y, WHITE)
	end
	
	def draw_particle(x, y, color)
		Gosu.draw_rect(x, y, 3, 3, color)
	end
end

Firepaint.new.show()
