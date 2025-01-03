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

# import HiGHS
# const OPTIMIZATION_MODULE = "HiGHS"

function new_ilp()
	ilp = nothing

	if OPTIMIZATION_MODULE == "HiGHS"
		ilp = JuMP.Model(HiGHS.Optimizer)
		HiGHS.Highs_resetGlobalScheduler(1)
	elseif OPTIMIZATION_MODULE == "Gurobi"    
		ilp = JuMP.Model(() -> Gurobi.Optimizer(GRB_ENV_REF[]))
	end
	
	#=
	jump.dev/JuMP.jl/stable/tutorials/getting_started/getting_started_with_JuMP/#An-example
	=#

	#=
	Note: I get an error when I call 
	JuMP.@variable(ilp, x >= 0, JuMP.Int)
	but not 
	JuMP.@variable(ilp, x >= 0, Int)
	
	For now, I ignore this issue.
	=#

	JuMP.@variable(ilp, x >= 0, Int)
	JuMP.@variable(ilp, 0 <= y <= 3, Int)
	
	coeff_1 = mod(rand(JuMP.Int), 20)
	coeff_2 = mod(rand(JuMP.Int), 20)

	JuMP.@objective(ilp, Min, coeff_1 * x + coeff_2 * y)

	JuMP.@constraint(ilp, c1, 6x + 8y >= 100)

	JuMP.@constraint(ilp, c2, 7x + 12y >= 120)

	ilp
end

function solve_two_ilps()
	ilp_1 = new_ilp()
	JuMP.optimize!(ilp_1)

	ilp_2 = new_ilp()
	JuMP.optimize!(ilp_2)
end

end
