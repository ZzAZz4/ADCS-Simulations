s = tf('s');
SAT_INERTIA = 0.0029;
SAT_LP_FILTER = 2;
X_GAIN_VALS = 0.02:0.02:2;

sys = 1/((s + SAT_LP_FILTER) * (SAT_INERTIA * s^2));

sim = Simulator(sys, X_GAIN_VALS);

% sim.plot("Settling Time", sim.settling_time)
% sim.plot("Overshoot", sim.overshoot)
% sim.plot("Undershoot", sim.undershoot)
% sim.plot("Peak", sim.peak)
% sim.plot("PeakTime", sim.peak_time)
% sim.plot("RiseTime", sim.rise_time)
sim.dump("./pid_sim_example.xls")