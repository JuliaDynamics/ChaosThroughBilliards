using DrWatson
@quickactivate "ChaosThroughBilliards"
include(srcdir("style.jl"))
using DynamicalSystems
using DataStructures: CircularBuffer

# %% Simulate
const L1 = 1.0
const L2 = 0.9

M = 1
u0 = [π/3, 0, 3π/4, -2]
u0s = [u0 .+ [0, 0, 0.005*i, 0] for i in 0:M-1]
tail = 200
dp = Systems.double_pendulum(u0; L1, L2)

datas = trajectory.(Ref(dp), 200, u0s; Δt = 0.005)

function xycoords(data)
    θ1 = data[:, 1]
    θ2 = data[:, 3]
    x1 = L1 * sin.(θ1)
    y1 = -L1 * cos.(θ1)
    x2 = x1 + L2 * sin.(θ2)
    y2 = y1 - L2 * cos.(θ2)
    return x1,x2,y1,y2
end

# x1,x2,y1,y2 = xycoords(data)
coords = xycoords.(datas)


# %% Plot
fig = Figure(); display(fig)
ax = fig[1,1] = Axis(fig)
ax.aspect = DataAspect()
l = 1.05(L1+L2)
xlims!(ax, -l, l)
ylims!(ax, -l, 0.5l)
colors = reverse(COLORS[1:M])
hidespines!(ax)
hidedecorations!(ax)

function maketraj!(ax, x2, y2, c)
    traj = CircularBuffer{Point2f0}(tail)
    fill!(traj, Point2f0(x2, y2))
    traj = Observable(traj)
    tailcol =  [RGBAf0(c.r, c.g, c.b, (i/tail)^2) for i in 1:tail]
    lines!(ax, traj; linewidth = 3, color = tailcol)
    return traj
end
function makerod!(ax, c)
    rod = Observable([Point2f0(0, 0), Point2f0(0, -L1), Point2f0(0, -L1-L2)])
    node = Observable(Point2f0(0, -L1))
    ball = Observable(Point2f0(0, -L1-L2))
    lines!(ax, rod; linewidth = 4, color = lighten_color(c))
    scatter!(ax, node; marker = :circle, strokewidth = 2, strokecolor = lighten_color(c),
        color = darken_color(c, 2), markersize = 8
    )
    scatter!(ax, ball; marker = :circle, strokewidth = 3, strokecolor = lighten_color(c),
        color = darken_color(c, 2), markersize = 12
    )
    return rod, node, ball
end

trajs = [maketraj!(ax, coords[j][2][1], coords[j][4][1], colors[j]) for j in 1:M]
rods = [makerod!(ax, c) for c in colors]

function update!(trajs, rods, coords, i = 1)
    for j in 1:length(u0s)
        traj = trajs[j]
        rod, node, ball = rods[j]
        x1, x2, y1, y2 = coords[j]
        push!(traj[], Point2f0(x2[i], y2[i]))
        traj[] = traj[]
        rod[] = [Point2f0(0, 0), Point2f0(x1[i], y1[i]), Point2f0(x2[i], y2[i])]
        node[] = Point2f0(x1[i], y1[i])
        ball[] = Point2f0(x2[i], y2[i])
    end
end

update!(trajs, rods, coords)

if false # make figure of zoomin
    x1,x2,y1,y2 = coords[1]
    z = 0.05
    xlims!(ax, x2[1]-z, x2[1]+z/10)
    ylims!(ax, y2[1]-z, y2[1]+z/10)
    
    file = projectdir("video", "doublependulum_zoom.png")
    GLMakie.save(file, fig)

    # Return to proper limits
    xlims!(ax, -l, l)
    ylims!(ax, -l, 0.5l)
end

# %% Animate
file = projectdir("video", "doublependulum_M=$(M).mp4")
mkpath(dirname(file))
record(fig, file; framerate = 60, compression = 10) do io
    for i = 1:3:6000
        update!(trajs, rods, coords, i)
        recordframe!(io)  # record a new frame
    end
end