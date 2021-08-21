using DrWatson
@quickactivate "ChaosThroughBilliards"
include(srcdir("style.jl"))

# re = billiard_rectangle(x, y)
# si = billiard_sinai(y/4, x, y)
# st = billiard_stadium(x-y, y)

bd = Billiard(Antidot([0.0, 0.0], 1.5, false))

InteractiveDynamics.obfill(::Antidot) = RGBAf0(0,0,0,0)
InteractiveDynamics.obls(::Antidot) = nothing
InteractiveDynamics.obcolor(::Antidot) = to_color(:white)

N = 8
ps = [Particle(0, 0, 2π*(i/N)) for i in 1:N]

# interactive_billiard(bd, ps; 
# backgroundcolor = :black, particle_size = 2.0, add_controls = false)

billiard_video(
    videodir("circle.mp4"), bd, deepcopy(ps);
    frames = 80, backgroundcolor = :black, colors = COLORS,
    tailwidth = 3.5, particle_size = 2, res = (1200, 1200),
    plot_particles = true,
    dt = 0.0001, speed = 150, tail = 10000, # this makes ultra fine temporal resolution
)
