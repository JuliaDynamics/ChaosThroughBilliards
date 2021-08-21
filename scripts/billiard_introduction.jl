using DrWatson
@quickactivate "ChaosThroughBilliards"
include(srcdir("style.jl"))

x = 1.0
y = 0.54

re = billiard_rectangle(x, y)
si = billiard_sinai(y/4, x, y)
st = billiard_stadium(x-y, y)

ps = [Particle(4x/5, y/5, π/9)]

# interactive_billiard(re, ps; 
# backgroundcolor = :black, res = MAXRES, particle_size = 2.0, add_controls = false)

for (bd, name) in zip((re, si), ("rect", "sinai"))
# for (bd, name) in zip((si,), ("sinai",))

billiard_video(
    videodir("mirror_$(name).mp4"), bd, deepcopy(ps);
    frames = 1200, backgroundcolor = :black, colors = COLORS,
    tailwidth = 3.5, particle_size = 2, res = (1200*x, 1200*y),
    plot_particles = true,
    dt = 0.0001, speed = 150, tail = 10000, # this makes ultra fine temporal resolution
)

end