using DrWatson
@quickactivate "ChaosThroughBilliards"
include(srcdir("style.jl"))
using DynamicalSystems, OrdinaryDiffEq

lo = Systems.lorenz()

# Lorenz
ds = Systems.lorenz()

u1 = [10,20,40.0]
u2 = [10,20,40.0 + 1e-3]
u3 = [20,10,40.0]
u0s = [u1, u2, u3]

idxs = (1, 2, 3)
diffeq = (alg = Tsit5(), dt = 0.005, adaptive = false)

M = 4
xs = range(-20, 20; length = M)
ys = range(-20, 20; length = M)
zs = range(0, 60; length = M)
u0s = [SVector(x, y, z) for x in xs for y in ys for z in zs]


colors = [CGRAD[(i-1)/length(u0s)] for i in 1:length(u0s)]


fig, obs, run = interactive_evolution(
    ds, u0s; idxs, tail = 100, diffeq, add_controls = false,
    plotkwargs = (transparency = true,), colors,
)

ax = content(fig[1,1])
ax.elevation = 0.2
ax.azimuth = 1.43

ax.limits = ((-20, 20), (-20,20), (0, 60))
ax.viewmode = :fit
hidedecorations!(ax)

# %% 
file = projectdir("video", "lorenz.mp4")
mkpath(dirname(file))
record(fig, file; framerate = 60) do io
    for i = 1:600
        run[] = !run[]
        ax.azimuth = ax.azimuth[] + 2π/2400
        recordframe!(io)  # record a new frame
    end
end

ax.azimuth = 4.833392041389046
file = projectdir("video", "lorenz_showcase.mp4")
record(fig, file; framerate = 90) do io
    for i = 1:600
        run[] = !run[]
        ax.azimuth = ax.azimuth[] + 2π/10000
        recordframe!(io)  # record a new frame
    end
end

# for i in 1:1000
#     run[] = !run[]
#     ax.azimuth = ax.azimuth[] + 2π/1200
#     # yield()
#     sleep(0.001)
# end
