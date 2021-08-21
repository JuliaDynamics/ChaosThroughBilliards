using DrWatson
@quickactivate "ChaosThroughBilliards"
include(srcdir("style.jl"))

psize = 2.0

bd = billiard_stadium(1.0, 1.0)

frames = 1800
dt = 0.0001
speed = 200

# billiard_video(
#     videodir("1_1particle.mp4"), bd, deepcopy(ps);
#     frames, backgroundcolor = :black, colors = [PURPLE],
#     plot_particles = true, tailwidth = 4, particle_size = psize, res = MAXRES,
#     dt, speed, tail = 20000, # this makes ultra fine temporal resolution
#     framerate = 60,
# )

# input:
colors = [PURPLE, TEAL]
f(p) = p.pos[2] # the function that obtains the data from the particle
total_span = 10.0

ps = particlebeam(1.0, 0.8, 0, 2, 0.0001, nothing)
ylim = (0, 1)
ylabel = "y"

billiard_video_timeseries(
    videodir("timeseries.mp4"), bd, ps, f;
    displayfigure = true, total_span, colors,
    frames, backgroundcolor = :black,
    plot_particles = true, tailwidth = 4, particle_size = psize, res = MAXRES,
    dt, speed, tail = 20000, # this makes ultra fine temporal resolution
    framerate = 60, ylabel
)
