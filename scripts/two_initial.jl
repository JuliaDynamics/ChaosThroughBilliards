using DrWatson
@quickactivate "ChaosThroughBilliards"
include(srcdir("style.jl"))

x = 1.0
y = 0.54

si = billiard_sinai(y/4, x, y)

ps = [Particle(4x/5, y/5, π/9), Particle(4x/5, y/5 + 1e-5, π/9)]

# interactive_billiard(re, ps; 
# backgroundcolor = :black, res = MAXRES, particle_size = 2.0, add_controls = false)

billiard_video(
    videodir("two_initial.mp4"), si, deepcopy(ps);
    frames = 1200, backgroundcolor = :black, colors = COLORS[1:2],
    tailwidth = 3.5, particle_size = 2, res = (1200*x, 1200*y),
    plot_particles = true,
    dt = 0.0001, speed = 150, tail = 10000, # this makes ultra fine temporal resolution
)

# %% Same video, with timeseries now
f(p) = p.pos[2] # the function that obtains the data from the particle
ylabel = "y"

billiard_video_timeseries(
    videodir("two_initial_timeseries.mp4"), si, deepcopy(ps), f;
    frames = 1200, backgroundcolor = :black, colors = COLORS[1:2],
    tailwidth = 3.5, particle_size = 2, res = (1200*x, 1200*y*2),
    plot_particles = true,
    dt = 0.0001, speed = 150, tail = 10000, # this makes ultra fine temporal resolution
    ylabel
)


# %% Also plot of timeseries and hopefully show exponential divergence
x1, y1, vx1, vy1, t1 = DynamicalBilliards.timeseries(ps[1], si, 20.0; dt = 0.1)
x2, y2, vx2, vy2, t2 = DynamicalBilliards.timeseries(ps[2], si, 20.0; dt = 0.1)
using LinearAlgebra
δ = Float64[]
for i in 1:min(length(t1), length(t2))
    push!(δ, sqrt((x1[i]-x2[i])^2 + (y1[i]-y2[i])^2 + (vx1[i]-vx2[i])^2 + (vy1[i]-vy2[i])^2))
end

fig = Figure()
ax = fig[1,1] = Axis(fig, xlabel = L"t", ylabel = L"\log(\delta)", xlabelsize= 32, ylabelsize= 32)
lines!(ax, log.(δ); color = COLORS[3])
# ax.xlabel = "time"
# ax.ylabel = "log(δ)"
display(fig)
# δ = abs.(y2[1:length(y1)] .- y1)
GLMakie.save(videodir("divergence.png"), fig)