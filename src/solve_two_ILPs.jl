#=
	I want to be able to use one Gurobi license to solve two problems
	back-to-back.
=#

function new_ilp()
	ilp = nothing

	if OPTIMIZATION_MODULE == "HiGHS"
		ilp = JuMP.Model(HiGHS.Optimizer)
		HiGHS.Highs_resetGlobalScheduler(1)
	elseif OPTIMIZATION_MODULE == "Gurobi"    
		ilp = JuMP.Model(Gurobi.Optimizer(GRB_ENV_REF[]))
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

end

function solve_two_ilps()
	ilp_1 = new_ilp()
	JuMP.optimize!(ilp_1)

	ilp_2 = new_ilp()
	JuMP.optimize!(ilp_2)
end