module JuMPGurobiExample

import JuMP
import MathOptInterface as MOI

#=
	I have a big computer with a Gurobi license, and a small one with
	no license.
	I want to do my dev work on small computer, and big runs on the big
	one, so I want to take advantage of the generic MathOptInterface to
	switch optimization libraries, using Gurobi where available, and
	defaulting to HiGHS if not.
=#

import Gurobi

# see ->-v
# jump.dev/JuMP.jl/stable/packages/Gurobi/#Reusing-the-same-Gurobi-environment-for-multiple-solves
const GRB_ENV_REF = Ref{Gurobi.Env}()

function __init__()
	global GRB_ENV_REF
	GRB_ENV_REF[] = Gurobi.Env()
	return
end

const OPTIMIZATION_MODULE = "Gurobi"

import HiGHS
const OPTIMIZATION_MODULE = "HiGHS"

include("solve_two_ILPs.jl")

end
