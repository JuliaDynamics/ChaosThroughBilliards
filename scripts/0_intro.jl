using DrWatson
@quickactivate "ChaosThroughBilliards"
include(srcdir("style.jl"))

ps = 2.0

bdsta = billiard_stadium(1.0, 1.0)

N = 300

billiard_video(
    videodir("intro$N.mp4"), bdsta, 1.0, 0.8, 0;
    frames = 1000, colors = COLORS[1:2],
    N = N, dx = 0.01,
    plot_particles = false, tailwidth = 1, particle_size = ps, res = MAXRES,
    dt = 0.0001, speed = 250, tail = 20000, # this makes ultra fine temporal resolution
)

println("Done.")
