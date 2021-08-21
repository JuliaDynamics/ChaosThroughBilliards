using InteractiveDynamics, DynamicalBilliards, GLMakie

# For 3b1b style
# BLUE = "#7BC3DC"
# BROWN = "#8D6238"

PURPLE = "#9134F1"
TEAL =  "#25D5DB"
GREEN = "#49C544"
RED = "#C32D2D"

TEALGREEN = "#20D2A0"
GREY = "#9a9a9a"


COLORS = to_color.([PURPLE, TEALGREEN, RED, GREY])
CGRAD = cgrad(COLORS)

# Overwrite default color of obstacles to white (to fit with black background)
InteractiveDynamics.obcolor(::Obstacle) = RGBf0(1, 1, 1)
InteractiveDynamics.obfill(::Obstacle) = RGBAf0(1, 1, 1, 0.4)
InteractiveDynamics.oblw(::Obstacle) = 4

videodir(args...) = projectdir("video", args...)

MAXRES = (1500, 900) # depends on monitor
MAXPS = 1.8


include("set_black_theme.jl")