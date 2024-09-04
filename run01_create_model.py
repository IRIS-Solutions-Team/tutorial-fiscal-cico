
import irispie as ir
import sys


m = ir.Simultaneous.from_file(
    "model-source/fiscal_ce.mdl",
)


# Steady-state parameters
m.assign(
    beta=1.03**(-1/4),
    beta_P=0.5,
    beta_K=1,
    eta=0,
    delta=0.04,
    nu=0,
    nu0=0,
    mu_C=1.20,
    mu_I=1.20,
    mu_Y=1.50,
    n=0.35,
    gamma_N=0.65,
)


# Directly calibrated steady-state characteristics
m.assign(
    ss_dA=1.02**(1/4),
    ss_dPc=1.025**(1/4),
    ss_Bg_NGDP=0,
    ss_PcG_NGDP=0.15,
)

# Transitory parameters
m.assign(
    psi_DLI=0,
    psi_C=0.7,
    rho_W=0.7,
    rho_A=0.8,
    xi_Pc=200,
    xi_Pi=100,
    xi_I=1,
)

# Monetary Policy Reaction Parameters
m.assign(
    rho_R=0.7,
    rho_R_bar=0.9,
    kappa_dPc=3.5,
)

# Fiscal Policy Reaction Parameters
m.assign(
    lambda_G1=0,
    lambda_G2=0.2,
    lambda_TXls1=0.2,
    lambda_TXls2=0,
)

# Reverse engineered steady-state values
m.assign(
    PIEy_NGDP=0,
    PcC_Vh_nu0=0,
    N=1,
)

# m.assign(
#     nu=0.03,
#     psi_DLI=0.8,
# )

m.assign(A=(1, 1.02**(1/4)), Pc=(1, 1.025**(1/4)))

p = ir.SteadyPlan(m)
p.fix_level(["A", "Pc"])

# 'exogenize', {'N', 'PIEy_NGDP', 'PcC_Vh_nu0'}, ...
# 'endogenize', {'upsilon', 'mu_Y', 'nu0'}, ...

p.exogenize(["N", "PIEy_NGDP", "PcC_Vh_nu0"])
p.endogenize(["upsilon", "mu_Y", "nu0"])

m.steady(plan=p, split_into_blocks=False, )
m.check_steady()


m.expand_num_variants(2, )

m[1].assign(ss_Bg_NGDP=4*0.20, )

p = ir.SteadyPlan(m)
p.fix(["A", "Pc"])

m.steady(plan=p, )
m.check_steady()
m.solve()

sim_span = ir.ii(1) >> ir.ii(40)

d = ir.Databox.steady(m[0], sim_span)

# s = m[1].simulate(d, sim_span, )
s, info = m[1].simulate(d, sim_span, method="stacked_time", return_info=True, )

evaluator = info["evaluator"]
data = info["data"]

sys.exit()


# smc = s.copy()
# smc.minus_control(m[0], d)
# 
# 
# ch = ir.Chartpack(
#     span=sim_span[0]-1 >> sim_span[-1],
# )
# 
# f = ch.add_figure("Government debt expansion")
# 
# f.add_charts([
#     "Private consumption: C",
#     "Private investment: I",
#     "Consumer inflation: dPc**4",
#     "Policy rate: R**4",
#     "Real wage: W_Pc",
#     "Employment: N",
# ], transform="100*(x-1)", )
# 
# f.add_charts([
#     "Govt consumption to GDP: PcG_NGDP",
#     "Govt debt to GDP: 100*Bg_NGDP/4",
#     "Tax revenues to GDP: TXls_NGDP",
# ], transform="100*x")
# 
# 
# info = ch.plot(smc, return_info=True, )
# 
# table = m.create_steady_table(
#     columns=["name", "steady_level", "compare_steady_level"],
#     save_to_csv="steady_table.csv",
# )
# 
