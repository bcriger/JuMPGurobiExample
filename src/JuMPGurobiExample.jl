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

try
    # see ->-v
    # jump.dev/JuMP.jl/stable/packages/Gurobi/#Reusing-the-same-Gurobi-environment-for-multiple-solves
    
    import Gurobi
    
    global const gurobi_env = Ref{Gurobi.Env}()
    # global const gurobi_env = Gurobi.Env()
    
    # function __init__()
    #     global gurobi_env
    #     gurobi_env[] = Gurobi.Env()
    #     return
    # end

    # assure an error will be generated without a valid license
    # _ = Gurobi.Env()

    # _ = JuMP.Model(() -> Gurobi.Optimizer(gurobi_env[]))

    global const OPTIMIZATION_MODULE = "Gurobi"
catch
    import HiGHS
    global const OPTIMIZATION_MODULE = "HiGHS"
end

include("solve_two_ILPs.jl")

end
