using DrWatson
@quickactivate "ChaosThroughBilliards"
include(srcdir("style.jl"))

x = 1.0
y = 0.54

si = billiard_sinai(y/4, x, y)
re = billiard_rectangle(x,  y)

ps = particlebeam(4x/5, y/5, π/9, 20, 0.01)

colors = COLORS[1:2]

bd = si


for (bd, name) in zip((si, re), ("sinai", "rect"))

ps = particlebeam(4x/5, y/5, π/9, 20, 0.01)

# function billiard_video(file::String, bd::Billiard, ps::Vector{<:AbstractParticle};
reslarge = (1200*x, 1200*y)
reszoom = (800, 800)
dt = 0.0001
speed = 10
tail = 1200
frames = 650
framerate = 60
particle_size = 2

# first video without any adjustments
file = videodir("stretching_$(name)_large.mp4")

billiard_video(
    file, bd, deepcopy(ps);
    frames, colors,
    tailwidth = 3.5, particle_size = 0.8, res = reslarge,
    plot_particles = true,
    dt, speed, tail = round(Int, tail*1.5)
)

vr = InteractiveDynamics._estimate_vr(bd)/8

ps = particlebeam(4x/5, y/5, π/9, 20, 0.01)

fig, allparobs, balls, vels, vr = interactive_billiard(bd, ps;
    res = reszoom, particle_size, tail, vr, add_controls = false, colors,
    displayfigure = false,
)
N = length(ps)
ci = N÷2 # index of chosen particle to zoom at and set axis limits
ax = content(fig[1,1]) # axis we need to be zooming in.
zx = 0.08 # zoom limits

file = videodir("stretching_$(name)_zoom.mp4")
Makie.inline!(true) # to not display figure while recording
record(fig, file, 1:frames; framerate) do j
# for j in 1:frames
    for i in 1:N
        parobs = allparobs[i]
        InteractiveDynamics.animstep!(parobs, bd, dt, true)
        balls[][i] = parobs.p.pos
        vels[][i] = vr*particle_size*parobs.p.vel
    end
    balls[] = balls[]
    vels[] = vels[]
    # Set axis limits
    pos = allparobs[ci].p.pos
    xlims!(ax, pos[1] - zx, pos[1] + zx)
    ylims!(ax, pos[2] - zx, pos[2] + zx)
    # sleep(0.000001)
    # yield()
    for _ in 1:speed
        for i in 1:N
            parobs = allparobs[i]
            InteractiveDynamics.animstep!(parobs, bd, dt, false)
        end
    end
end
Makie.inline!(false)


end